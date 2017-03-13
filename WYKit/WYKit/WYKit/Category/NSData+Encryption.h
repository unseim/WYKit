//
//  NSData+Encryption.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

@interface NSData (Encryption)

/**
 AES加密
 
 @param key 加密密匙
 @return    NSData
 */
- (NSData *)AES256EncryptWithKey:(NSData *)key;

/**
 AES解密
 
 @param key 解密密匙(必须同加密密钥一样)
 @return    NSData
 */
- (NSData *)AES256DecryptWithKey:(NSData *)key;

/**
 *  base64加密
 *
 */
- (NSString *)base64EncodedStringFrom:(NSData *)data;

/**
 *  base64解密
 *
 */
- (NSData *)dataWithBase64EncodedString:(NSString *)string;

/**
 base64解密 + AES解密
 
 @param     string 密文
 @param     keyData 密匙
 @return    NSString
 */
- (NSString *)dataBase64AndAESWithEncodedString:(NSString *)string keyData:(NSData *)keyData;

/**
 *  创建一个密匙(Data类的密匙)
 *
 */
- (NSData *)ctreatAKeyData;


@end
