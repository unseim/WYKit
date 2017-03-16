//
//  NSMutableString+WYKit.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

@interface NSMutableString (WYKit)

/** 替换字符串 */
- (void)replaceString:(NSString *)searchString withString:(NSString *)newString;

/** 去除空格 */
- (void)removeSpace;

/** 将字符串中“Nil”和“Null”去除 */
- (void)removeNilAndNull;


@end
