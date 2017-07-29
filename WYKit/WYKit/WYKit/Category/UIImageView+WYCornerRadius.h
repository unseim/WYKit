//
//  UIImageView+WYCornerRadius.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView (WYCornerRadius)

/** 初始化 切成指定圆角的半径 和 方向 的图片 */
- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius
                             rectCornerType:(UIRectCorner)rectCornerType;

/** 切成指定圆角的半径 和 方向 的图片 */
- (void)cornerRadiusAdvance:(CGFloat)cornerRadius
                rectCornerType:(UIRectCorner)rectCornerType;

/** 初始化方法 切成圆形图片 */
- (instancetype)initWithRoundingRectImageView;

/** 切成圆形图片 */
- (void)cornerRadiusRoundingRect;

/** 给图片加边框 */
- (void)attachBorderWidth:(CGFloat)width
                       color:(UIColor *)color;


@end
