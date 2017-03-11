//
//  NSData+Encryption.h
//  WYKit
//
//  Created by 汪年成 on 17/2/6.
//  Copyright © 2017年 之静之初. All rights reserved.
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
