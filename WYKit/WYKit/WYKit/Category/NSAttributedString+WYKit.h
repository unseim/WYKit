//
//  NSAttributedString+WYKit.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (WYKit)

/** 由于系统计算富文本的高度不正确，自己写了方法 */
 - (CGFloat)heightWithContainWidth:(CGFloat)width;


@end
