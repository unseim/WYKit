//
//  NSString+WYKit.m
//  WYKit
//
//  Created by 汪年成 on 16/12/16.
//  Copyright © 2016年 之静之初. All rights reserved.
//

#import "NSString+WYKit.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (WYKit)

/* 搜索两个字符之间的字符串 */
+ (NSString *)searchInString:(NSString *)string
                   charStart:(char)start
                     charEnd:(char)end
{
    int inizio = 0, stop = 0;
    for(int i = 0; i < [string length]; i++)
    {
        // 定位起点索引字符
        if([string characterAtIndex:i] == start)
        {
            inizio = i+1;
            i += 1;
        }
        // 定位结束索引字符
        if([string characterAtIndex:i] == end)
        {
            stop = i;
            break;
        }
    }
    stop -= inizio;
    // 裁剪字符串
    NSString *string2 = [[string substringFromIndex:inizio-1] substringToIndex:stop+1];
    return string2;
}

/* 搜索两个字符之间的字符串 */
- (NSString *)searchCharStart:(char)start
                      charEnd:(char)end
{
    int inizio = 0, stop = 0;
    for(int i = 0; i < [self length]; i++)
    {
        if([self characterAtIndex:i] == start)
        {
            inizio = i+1;
            i += 1;
        }
        if([self characterAtIndex:i] == end)
        {
            stop = i;
            break;
        }
    }
    stop -= inizio;
    NSString *string = [[self substringFromIndex:inizio-1] substringToIndex:stop+1];
    
    return string;
}

/* 创建一个MD5字符串 */
- (NSString *)MD5
{
    if(self == nil || [self length] == 0)
        return nil;
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    for(i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    return [ms copy];
}

/* 创建一个SHA1字符串 */
- (NSString *)SHA1
{
    if(self == nil || [self length] == 0)
        return nil;
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH], i;
    CC_SHA1([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    for(i=0;i<CC_SHA1_DIGEST_LENGTH;i++)
    {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    return [ms copy];
}

/* 创建一个SHA256字符串 */
- (NSString *)SHA256
{
    if(self == nil || [self length] == 0)
        return nil;
    
    unsigned char digest[CC_SHA256_DIGEST_LENGTH], i;
    CC_SHA256([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    for(i = 0;i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    return [ms copy];
}

/* 创建一个SHA512字符串 */
- (NSString *)SHA512
{
    if(self == nil || [self length] == 0)
        return nil;
    
    unsigned char digest[CC_SHA512_DIGEST_LENGTH], i;
    CC_SHA512([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    for(i=0;i<CC_SHA512_DIGEST_LENGTH;i++)
    {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    return [ms copy];
}

/* 检查自身是否追加字符串 */
- (BOOL)hasString:(NSString *)substring
{
    return !([self rangeOfString:substring].location == NSNotFound);
}

/* 检查自身是否是一个email */
- (BOOL)isEmail
{
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    // 获取指点的谓语
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    // 评估对象的谓词
    return [regExPredicate evaluateWithObject:[self lowercaseString]];
}

/* 检查给定的字符串是否是一个email */
+ (BOOL)isEmail:(NSString *)email
{
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [regExPredicate evaluateWithObject:[email lowercaseString]];
}

/* 字符串转换为UTF8 */
+ (NSString *)convertToUTF8Entities:(NSString *)string
{
    NSString *isoEncodedString = [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
                                                                  [string stringByReplacingOccurrencesOfString:@"%27" withString:@"'"]
                                                                  stringByReplacingOccurrencesOfString:[@"%e2%80%99" capitalizedString] withString:@"’"]
                                                                 stringByReplacingOccurrencesOfString:[@"%2d" capitalizedString] withString:@"-"]
                                                                stringByReplacingOccurrencesOfString:[@"%c2%ab" capitalizedString] withString:@"«"]
                                                               stringByReplacingOccurrencesOfString:[@"%c2%bb" capitalizedString] withString:@"»"]
                                                              stringByReplacingOccurrencesOfString:[@"%c3%80" capitalizedString] withString:@"À"]
                                                             stringByReplacingOccurrencesOfString:[@"%c3%82" capitalizedString] withString:@"Â"]
                                                            stringByReplacingOccurrencesOfString:[@"%c3%84" capitalizedString] withString:@"Ä"]
                                                           stringByReplacingOccurrencesOfString:[@"%c3%86" capitalizedString] withString:@"Æ"]
                                                          stringByReplacingOccurrencesOfString:[@"%c3%87" capitalizedString] withString:@"Ç"]
                                                         stringByReplacingOccurrencesOfString:[@"%c3%88" capitalizedString] withString:@"È"]
                                                        stringByReplacingOccurrencesOfString:[@"%c3%89" capitalizedString] withString:@"É"]
                                                       stringByReplacingOccurrencesOfString:[@"%c3%8a" capitalizedString] withString:@"Ê"]
                                                      stringByReplacingOccurrencesOfString:[@"%c3%8b" capitalizedString] withString:@"Ë"]
                                                     stringByReplacingOccurrencesOfString:[@"%c3%8f" capitalizedString] withString:@"Ï"]
                                                    stringByReplacingOccurrencesOfString:[@"%c3%91" capitalizedString] withString:@"Ñ"]
                                                   stringByReplacingOccurrencesOfString:[@"%c3%94" capitalizedString] withString:@"Ô"]
                                                  stringByReplacingOccurrencesOfString:[@"%c3%96" capitalizedString] withString:@"Ö"]
                                                 stringByReplacingOccurrencesOfString:[@"%c3%9b" capitalizedString] withString:@"Û"]
                                                stringByReplacingOccurrencesOfString:[@"%c3%9c" capitalizedString] withString:@"Ü"]
                                               stringByReplacingOccurrencesOfString:[@"%c3%a0" capitalizedString] withString:@"à"]
                                              stringByReplacingOccurrencesOfString:[@"%c3%a2" capitalizedString] withString:@"â"]
                                             stringByReplacingOccurrencesOfString:[@"%c3%a4" capitalizedString] withString:@"ä"]
                                            stringByReplacingOccurrencesOfString:[@"%c3%a6" capitalizedString] withString:@"æ"]
                                           stringByReplacingOccurrencesOfString:[@"%c3%a7" capitalizedString] withString:@"ç"]
                                          stringByReplacingOccurrencesOfString:[@"%c3%a8" capitalizedString] withString:@"è"]
                                         stringByReplacingOccurrencesOfString:[@"%c3%a9" capitalizedString] withString:@"é"]
                                        stringByReplacingOccurrencesOfString:[@"%c3%af" capitalizedString] withString:@"ï"]
                                       stringByReplacingOccurrencesOfString:[@"%c3%b4" capitalizedString] withString:@"ô"]
                                      stringByReplacingOccurrencesOfString:[@"%c3%b6" capitalizedString] withString:@"ö"]
                                     stringByReplacingOccurrencesOfString:[@"%c3%bb" capitalizedString] withString:@"û"]
                                    stringByReplacingOccurrencesOfString:[@"%c3%bc" capitalizedString] withString:@"ü"]
                                   stringByReplacingOccurrencesOfString:[@"%c3%bf" capitalizedString] withString:@"ÿ"]
                                  stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    
    return isoEncodedString;
}

/* 编码给定的字符串成Base64 */
+ (NSString *)encodeToBase64:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

/* 编码自身成Base64 */
- (NSString *)encodeToBase64
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

/* 解码给定的字符串成Base64 */
+ (NSString *)decodeBase64:(NSString *)string
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/* 解码自身成Base64 */
- (NSString *)decodeBase64
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/* 转换自身为开头大写字符串 */
- (NSString *)sentenceCapitalizedString
{
    if(![self length])
    {
        return [NSString string];
    }
    NSString *uppercase = [[self substringToIndex:1] uppercaseString];
    NSString *lowercase = [[self substringFromIndex:1] lowercaseString];
    
    return [uppercase stringByAppendingString:lowercase];
}

/* 返回一个从时间戳人类易读的字符串 */
- (NSString *)dateFromTimestamp
{
    NSString *year = [self substringToIndex:4];
    NSString *month = [[self substringFromIndex:5] substringToIndex:2];
    NSString *day = [[self substringFromIndex:8] substringToIndex:2];
    NSString *hours = [[self substringFromIndex:11] substringToIndex:2];
    NSString *minutes = [[self substringFromIndex:14] substringToIndex:2];
    
    return [NSString stringWithFormat:@"%@/%@/%@ %@:%@", day, month, year, hours, minutes];
}

/* 自编码成编码的URL字符串 */
- (NSString *)urlEncode
{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for(int i = 0; i < sourceLen; ++i)
    {
        const unsigned char thisChar = source[i];
        
        if(thisChar == ' ')
        {
            [output appendString:@"+"];
        }
        else if(thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' || (thisChar >= 'a' && thisChar <= 'z') || (thisChar >= 'A' && thisChar <= 'Z') || (thisChar >= '0' && thisChar <= '9'))
        {
            [output appendFormat:@"%c", thisChar];
        }
        else
        {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    
    return output;
}

#pragma mark - 获得系统当前日期和时间
+ (nullable NSString *)WY_time_getCurrentDateAndTime
{
    //获得系统日期
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *morelocationString = [dateformatter stringFromDate:senddate];
    return morelocationString;
}

#pragma mark - 时间戳转换
#pragma mark 时间戳转换【YYYY-MM-dd HH:mm:ss】
+ (nullable NSString *)WY_time_getCurrentDateAndTimeWithTimeString:(nullable NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[string intValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

#pragma mark 时间戳转换【YYYY-MM-dd】
+ (nullable NSString *)WY_time_getDateWithTimeString:(nullable NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[string intValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

#pragma mark 时间戳转换【HH:mm】
+ (nullable NSString *)WY_time_getTimeWithTimeString:(nullable NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm"];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    // 时间戳转换
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[string intValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

#pragma mark 时间转换时间戳
+ (nullable NSString *)WY_time_getTimeStamp
{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    // 时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
}


@end
