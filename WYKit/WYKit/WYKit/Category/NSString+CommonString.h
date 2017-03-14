//
//  NSString+CommonString.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//
#import <Foundation/Foundation.h>

@interface NSString (CommonString)

/** String转URL */
- (NSURL *)wy_url;

/** 秒数时间转换 */
+ (NSString *)distanceTimeWithBeforeTime:(double)time;

/** 过滤HTML标签 */
+ (NSString *)removeStringIntheHTML:(NSString *)html;

/** 随机验证码字符串 */
+ (NSString *)RandomString:(double)number;

/** 判断用户输入是否含有emoji表情 */
+ (BOOL)stringContainsEmoji:(NSString *)string;

/** 过滤emoji表情 */
+ (NSString *)removeStringIntheEmoji:(NSString *)string;

/** 查看当前版本号 */
+ (NSString *)getAppVersion;

/** 获取App的build版本 */
+ (NSString *)getAppBuildVersion;

/** 获取App名称 */
+ (NSString *)getAppName;

/** 判断是否为手机号码 */
+ (BOOL)isValidPhoneWithString:(NSString *)phoneString;

/** 判断字符串是否包含空格 */
+ (BOOL)isBlank:(NSString *)str;

/** 邮箱验证 */
- (BOOL)isValidEmail;

/** 车牌号验证 */
- (BOOL)isValidCarNo;

/** 网址验证 */
- (BOOL)isValidUrl;

/** 是否邮政编码 */
- (BOOL)isValidPostalcode;

/** 是否是银行卡 */
- (BOOL)isValidBankCard;

/** 是否纯汉字 */
- (BOOL)isValidChinese;

/** 是否符合IP格式 */
- (BOOL)isValidIP;

/** 身份证验证 */
- (BOOL)isValidIdCardNum;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,数字，字母，其他字符，首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     containDigtal   包含数字
 @param     containLetter   包含字母
 @param     containOtherCharacter   其他字符
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
              containDigtal:(BOOL)containDigtal
              containLetter:(BOOL)containLetter
      containOtherCharacter:(NSString *)containOtherCharacter
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/** 去掉两端空格和换行符 */
- (NSString *)stringByTrimmingBlank;

/** 工商税号 */
- (BOOL)isValidTaxNo;

/** 判断字符串中是否含有非法字符 */
+ (BOOL)isContainErrorCharacter:(NSString *)content;

/** 判断字符串中包含空格换行 */
+ (BOOL)isEmpty:(NSString* )string;

/** 截取字符串中的数字 */
+ (NSString *)getPhoneNumberFomat:(NSString *)number;

/** 获取UDID 手机标识 */
+ (NSString *)getUDID;

/** 获取设备联网IP地址 */
+ (NSString *)getIPAddress;

@end
