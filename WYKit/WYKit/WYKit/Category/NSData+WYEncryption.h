//
//  NSData+WYEncryption.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

@interface NSData (WYEncryption)

#pragma mark - 加密

/** AES加密 */
- (NSData *)AES256EncryptWithKey:(NSData *)key;

/** AES解密 */
- (NSData *)AES256DecryptWithKey:(NSData *)key;

/** Base64加密 */
- (NSString *)base64EncodedStringFrom:(NSData *)data;

/** Base64解密 */
- (NSData *)dataWithBase64EncodedString:(NSString *)string;

/** Base64解密 + AES解密 */
- (NSString *)dataBase64AndAESWithEncodedString:(NSString *)string keyData:(NSData *)keyData;

/** 创建一个密匙(Data类的密匙) */
- (NSData *)ctreatAKeyData;


@end
