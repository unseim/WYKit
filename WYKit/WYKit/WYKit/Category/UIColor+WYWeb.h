//
//  UIColor+WYWeb.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface UIColor (WYWeb)

/** 随机颜色 */
+ (instancetype)randomColor;

/** 获取 canvas 用的颜色字符串 */
- (NSString *)canvasColorString;

/** 获取网页颜色字串 */
- (NSString *)webColorString;

@end
