//
//  NSAttributedString+WYKit.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (WYKit)

/** 由于系统计算富文本的高度不正确，自己写了方法 */
 - (CGFloat)heightWithContainWidth:(CGFloat)width;


@end
