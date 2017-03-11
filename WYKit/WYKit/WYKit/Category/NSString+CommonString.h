//
//  NSString+CommonString.h
//  WYKit
//
//  Created by 汪年成 on 16/12/22.
//  Copyright © 2016年 之静之初. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CommonString)
/**
 *  String转URL
 */
- (NSURL *)wy_url;

/**
 *  秒数时间转换
 */
+ (NSString *)distanceTimeWithBeforeTime:(double)time;

/**
 *  过滤HTML标签
 */
+ (NSString *)removeStringIntheHTML:(NSString *)html;

/**
 *  随机验证码字符串
 */
+ (NSString *)RandomString:(double)number;

/**
 *  判断用户输入是否含有emoji
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;

/**
 *  过滤emoji
 */
+ (NSString *)removeStringIntheEmoji:(NSString *)string;

/**
 *  查看当前版本号
 */
+ (NSString *)getAppVersion;

/**
 *  获取App的build版本
 */
+ (NSString *)getappBuildVersion;

/**
 *  获取App名称
 */
+ (NSString *)getappName;

/**
 *  判断是否为手机号码
 */
+ (BOOL)isValidPhoneWithString:(NSString *)phoneString;

/**
 * 判断字符串是否包含空格
 */
+ (BOOL)isBlank:(NSString *)str;

/**
 *  判断字符串中是否含有非法字符
 */
+ (BOOL)isContainErrorCharacter:(NSString *)content;

/**
 *  判断字符串中包含空格换行
 */
+ (BOOL)isEmpty:(NSString* )string;

/**
 *  截取字符串中的数字
 */
+ (NSString *)getPhoneNumberFomat:(NSString *)number;

/**
 *  获取UDID 手机标识
 */
+ (NSString *)getUDID;

/**
 *  获取设备联网IP地址
 */
+ (NSString *)getIPAddress;

@end
