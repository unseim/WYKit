//
//  NSString+WYKit.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

@interface NSString (WYKit)

/** 搜索两个字符之间的字符串 */
+ (nullable NSString *)searchInString:(nullable NSString *)string
                   charStart:(char)start
                     charEnd:(char)end;

/** 搜索两个字符之间的字符串 */
- (nullable NSString *)searchCharStart:(char)start
                      charEnd:(char)end;

/** 创建一个MD5字符串 */
- (nullable NSString *)MD5;

/** 创建一个SHA1字符串 */
- (nullable NSString *)SHA1;

/** 创建一个SHA256字符串 */
- (nullable NSString *)SHA256;

/** 创建一个SHA512字符串 */
- (nullable NSString *)SHA512;

/** 检查自身是否追加字符串 */
- (BOOL)hasString:(nullable NSString *)substring;

/** 检查自身是否是一个email */
- (BOOL)isEmail;

/** 检查给定的字符串是否是一个email */
+ (BOOL)isEmail:(nullable NSString *)email;

/** 字符串转换为UTF8 */
+ (nullable NSString *)convertToUTF8Entities:(nullable NSString *)string;

/** 编码给定的字符串成Base64 */
+ (nullable NSString *)encodeToBase64:(nullable NSString *)string;

/** 编码自身成Base64 */
- (nullable NSString *)encodeToBase64;

/** 解码给定的字符串成Base64 */
+ (nullable NSString *)decodeBase64:(nullable NSString *)string;

/** 解码自身成Base64 */
- (nullable NSString *)decodeBase64;

/** 转换自身为开头大写字符串 */
- (nullable NSString *)sentenceCapitalizedString;

/** 返回一个从时间戳人类易读的字符串 */
- (nullable NSString *)dateFromTimestamp;

/** 自编码成编码的URL字符串 */
- (nullable NSString *)urlEncode;

#pragma mark - *****  日期时间处理 类
/** 获得系统当前日期和时间 */
+ (nullable NSString *)time_getCurrentDateAndTime;

/** 时间戳转换【YYYY-MM-dd HH:mm:ss】 */
+ (nullable NSString *)time_getCurrentDateAndTimeWithTimeString:(nullable NSString *)string;

/** 时间戳转换【YYYY-MM-dd】 */
+ (nullable NSString *)time_getDateWithTimeString:(nullable NSString *)string;

/** 时间戳转换【HH:mm】 */
+ (nullable NSString *)time_getTimeWithTimeString:(nullable NSString *)string;

/** 时间转换时间戳  */
+ (nullable NSString *)time_getTimeStamp;

/** 判断字符串是否为空 */
- (BOOL)empty;

/** 判断是否为整型 */
- (BOOL)isInteger;

/** 判断是否为浮点型 */
- (BOOL)isFloat;

/** 判断是否含有数字 */
- (BOOL)isHasNumder;

/** 判断是否url */
- (BOOL)isUrl;

/** 匹配数字 */
- (BOOL)isNumbers;

/** 匹配英文字母 */
- (BOOL)isLetter;

/** 匹配大写英文字母 */
- (BOOL)isCapitalLetter;

/** 匹配小写英文字母 */
- (BOOL)isSmallLetter;

/** 匹配数字+英文字母 */
- (BOOL)isLetterAndNumbers;

/** 匹配中文，英文字母和数字及_ */
- (BOOL)isChineseAndLetterAndNumberAndBelowLine;

/** 匹配中文，英文字母和数字及_ 并限制字数 */
- (BOOL)isChineseAndLetterAndNumberAndBelowLine4to10;

/** 匹配含有汉字、数字、字母、下划线不能以下划线开头和结尾 */
- (BOOL)isChineseAndLetterAndNumberAndBelowLineNotFirstOrLast;

/** 检测是否含有某个字符 */
- (BOOL)containString:(NSString * _Nonnull)string;

/** 是否含有汉字 */
- (BOOL)containsChineseCharacter;

/** 计算String中英混合字数 */
- (NSInteger)stringLength;

/** email 转换为 913******@qq.com 形式 */
- (NSString * _Nonnull)emailChangeToPrivacy;

/** 计算字符串宽度 */
- (CGSize)heightWithWidth:(CGFloat)width
                  andFont:(CGFloat)font;

/** 计算字符串高度 （多行）*/
- (CGSize)widthWithHeight:(CGFloat)height
                  andFont:(CGFloat)font;



@end
