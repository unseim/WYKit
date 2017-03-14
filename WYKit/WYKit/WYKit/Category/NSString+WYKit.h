//
//  NSString+WYKit.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

@interface NSString (WYKit)
/**
 *  搜索两个字符之间的字符串。
 *  例如: "This is a test" 的开始字符'h'和结束字符't'将返回"his is a "
 */
+ (NSString *)searchInString:(NSString *)string
                   charStart:(char)start
                     charEnd:(char)end;

/**
 *  搜索两个字符之间的字符串。
 *  例如: "This is a test" 的开始字符'h'和结束字符't'将返回"his is a "
 */
- (NSString *)searchCharStart:(char)start
                      charEnd:(char)end;

/** 创建一个MD5字符串 */
- (NSString *)MD5;

/** 创建一个SHA1字符串 */
- (NSString *)SHA1;

/** 创建一个SHA256字符串 */
- (NSString *)SHA256;

/** 创建一个SHA512字符串 */
- (NSString *)SHA512;

/** 检查自身是否追加字符串 */
- (BOOL)hasString:(NSString *)substring;

/** 检查自身是否是一个email */
- (BOOL)isEmail;

/** 检查给定的字符串是否是一个email */
+ (BOOL)isEmail:(NSString *)email;

/** 字符串转换为UTF8 */
+ (NSString *)convertToUTF8Entities:(NSString *)string;

/** 编码给定的字符串成Base64 */
+ (NSString *)encodeToBase64:(NSString *)string;

/** 编码自身成Base64 */
- (NSString *)encodeToBase64;

/** 解码给定的字符串成Base64 */
+ (NSString *)decodeBase64:(NSString *)string;

/** 解码自身成Base64 */
- (NSString *)decodeBase64;

/**
 *  转换自身为开头大写字符串.
 *  例如: "This is a Test" 将返回 "This is a test"
 "this is a test"  将返回 "This is a test"
 */
- (NSString *)sentenceCapitalizedString;

/** 返回一个从时间戳人类易读的字符串 */
- (NSString *)dateFromTimestamp;

/** 自编码成编码的URL字符串 */
- (NSString *)urlEncode;

#pragma mark - *****  日期时间处理 类

/** 获得系统当前日期和时间 */
+ (nullable NSString *)WY_time_getCurrentDateAndTime;

/** 时间戳转换【YYYY-MM-dd HH:mm:ss】 */
+ (nullable NSString *)WY_time_getCurrentDateAndTimeWithTimeString:(nullable NSString *)string;

/** 时间戳转换【YYYY-MM-dd】 */
+ (nullable NSString *)WY_time_getDateWithTimeString:(nullable NSString *)string;

/** 时间戳转换【HH:mm】 */
+ (nullable NSString *)WY_time_getTimeWithTimeString:(nullable NSString *)string;

/** 时间转换时间戳  */
+ (nullable NSString *)WY_time_getTimeStamp;


@end
