//
//  NSString+CommonString.m
//  WYKit
//
//  Created by 汪年成 on 16/12/22.
//  Copyright © 2016年 之静之初. All rights reserved.
//

#import "NSString+CommonString.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation NSString (CommonString)

// String 转 URL
- (NSURL *)wy_url {
    return [NSURL URLWithString:self];
}

// 秒数时间转换
+ (NSString *)distanceTimeWithBeforeTime:(double)time {
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - time;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    if (distanceTime < 60) {
        //小于一分钟
        distanceStr = @"刚刚";
    } else if (distanceTime <60*60) {
        //时间小于一个小时
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    } else if (distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]) {
        //时间小于一天
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
    } else if (distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        } else {
            [df setDateFormat:@"MM-dd HH:mm"];
            distanceStr = [df stringFromDate:beDate];
        }
        
    } else if (distanceTime <24*60*60*365) {
        [df setDateFormat:@"MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    } else {
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}

// 过滤 HTML 标签
+ (NSString *)removeStringIntheHTML:(NSString *)html {
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        [theScanner scanUpToString:@">" intoString:&text] ;
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text]withString:@""];
    }
    
    NSString *str1 = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"—"];
    NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
    NSString *str4 = [str3 stringByReplacingOccurrencesOfString:@"&hellip;" withString:@"…"];
    NSString *str5 = [str4 stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
    NSString *str6 = [str5 stringByReplacingOccurrencesOfString:@"&bull;" withString:@"•"];
    NSString *str7 = [str6 stringByReplacingOccurrencesOfString:@"&omega;" withString:@"Ω"];
    
    return str7;
}

// 随机字符串
+ (NSString *)RandomString:(double)number {
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < number; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
            
        } else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

// 判断用户输入是否含有emoji
+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    return returnValue;
}

// 过滤emoji
+ (NSString *)removeStringIntheEmoji:(NSString *)string {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:string
                                                               options:0
                                                                 range:NSMakeRange(0, [string length])
                                                          withTemplate:@""];
    return modifiedString;
}

// 查看App的当前版本号
+ (NSString *)getAppVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

//  获取App的build版本
+ (NSString *)getappBuildVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
     NSString *appBuildVersion = [infoDic objectForKey:@"CFBundleVersion"];
    return appBuildVersion;
}

//  获取App名称
+ (NSString *)getappName {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    return appName;
}

//  判断是否为手机号
+ (BOOL)isValidPhoneWithString:(NSString *)phoneString
{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189,177,173,181(增加)
     */
    NSString * CT = @"^((133)|(153)|(17[7,3])|(18[0,1,9]))\\d{8}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phoneString] == YES)
        || ([regextestcm evaluateWithObject:phoneString] == YES)
        || ([regextestct evaluateWithObject:phoneString] == YES)
        || ([regextestcu evaluateWithObject:phoneString] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


//  判断字符串是否包含空格
+ (BOOL)isBlank:(NSString *)str {
    NSRange _range = [str rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        return YES;
    }
    else {
        return NO;
    }
}

//  判断字符串中是否含有非法字符
+ (BOOL)isContainErrorCharacter:(NSString *)content {
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:content]) {
        return YES;
    }
    return NO;
}

//  判断字符串中包含空格换行
+ (BOOL)isEmpty:(NSString* )string {
    if (!string) {
        return true;
    }
    else {
        NSCharacterSet *chara = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString* str =[string stringByTrimmingCharactersInSet:chara];
        if (str.length ==0) {
            return true;
        }
        else{
            return false;
        }
    }
}

//  截取字符串中的数字
+ (NSString *)getPhoneNumberFomat:(NSString *)number {
    NSMutableArray *characters = [NSMutableArray array];
    NSMutableString *mutStr = [NSMutableString string];
    // 分离出字符串中的所有字符，并存储到数组characters中
    for (int i = 0; i < number.length; i ++) {
        NSString *subString = [number substringToIndex:i + 1];
        
        subString = [subString substringFromIndex:i];
        
        [characters addObject:subString];
    }
    // 利用正则表达式，匹配数组中的每个元素，判断是否是数字，将数字拼接在可变字符串mutStr中
    for (NSString *b in characters) {
        NSString *regex = @"^[0-9]*$";
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];// 谓词
        BOOL isShu = [pre evaluateWithObject:b];// 对b进行谓词运算
        if (isShu) {
            [mutStr appendString:b];
        }
    }
    return mutStr;
}

//  获取设备联网IP地址
+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

//  获取UDID
+ (NSString *)getUDID
{
    return [[NSUUID UUID] UUIDString];
}

@end
