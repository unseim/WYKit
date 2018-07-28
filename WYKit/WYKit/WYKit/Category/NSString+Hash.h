//
//  NSString+Hash.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

@interface NSString (Hash)

#pragma mark - 加密
/** MD5 加密 */
- (NSString *)md5String;

/** SHA1 加密*/
- (NSString *)sha1String;

/** SHA 256 加密 */
- (NSString *)sha256String;

/** SHA 512 加密 */
- (NSString *)sha512String;


#pragma mark - HMAC 加密
/** HMAC MD5 加密 */
- (NSString *)hmacMD5StringWithKey:(NSString *)key;

/**
 *  计算HMAC SHA1 加密 */
- (NSString *)hmacSHA1StringWithKey:(NSString *)key;

/** HMAC SHA256 加密*/
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;

/** HMAC SHA512 加密 */
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;


#pragma mark - 文件加密

/** 文件的MD5 加密*/
- (NSString *)fileMD5Hash;

/** 文件的SHA1 加密 */
- (NSString *)fileSHA1Hash;

/** 文件的SHA256 加密 */
- (NSString *)fileSHA256Hash;

/** 文件的SHA512 加密 */
- (NSString *)fileSHA512Hash;

@end
