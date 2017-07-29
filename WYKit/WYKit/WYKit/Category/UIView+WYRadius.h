//
//  UIView+WYRadius.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>
#import "UIImage+WYRadius.h"

@interface UIView (RoundedCorner)

typedef void (^WYRoundedCornerCompletionBlock)(UIImage * image);

/**设置圆角背景图，默认 UIViewContentModeScaleAspectFill 模式*/
- (void)setImageWithCornerRadius:(CGFloat)radius
                              image:(UIImage *)image;

/**设置圆角背景图，默认 UIViewContentModeScaleAspectFill 模式*/
- (void)setImageWithWYRadius:(WYRadius)radius
                          image:(UIImage *)image;

/**设置 contentMode 模式的圆角背景图*/
- (void)setImageWithCornerRadius:(CGFloat)radius
                              image:(UIImage *)image
                        contentMode:(UIViewContentMode)contentMode;

/**设置 contentMode 模式的圆角背景图*/
- (void)setImageWithWYRadius:(WYRadius)radius
                          image:(UIImage *)image
                    contentMode:(UIViewContentMode)contentMode;

/**设置圆角边框*/
- (void)setImageWithCornerRadius:(CGFloat)radius
                        borderColor:(UIColor *)borderColor
                        borderWidth:(CGFloat)borderWidth
                    backgroundColor:(UIColor *)backgroundColor;

/**设置圆角边框*/
- (void)setImageWithWYRadius:(WYRadius)radius
                    borderColor:(UIColor *)borderColor
                    borderWidth:(CGFloat)borderWidth
                backgroundColor:(UIColor *)backgroundColor;

/**配置所有属性配置圆角背景图*/
- (void)setImageWithWYRadius:(WYRadius)radius
                          image:(UIImage *)image
                    borderColor:(UIColor *)borderColor
                    borderWidth:(CGFloat)borderWidth
                backgroundColor:(UIColor *)backgroundColor
                    contentMode:(UIViewContentMode)contentMode;

/**配置所有属性配置圆角背景图*/
- (void)setImageWithWYRadius:(WYRadius)radius
                          image:(UIImage *)image
                    borderColor:(UIColor *)borderColor
                    borderWidth:(CGFloat)borderWidth
                backgroundColor:(UIColor *)backgroundColor
                    contentMode:(UIViewContentMode)contentMode
                           size:(CGSize)size
                       forState:(UIControlState)state
                     completion:(WYRoundedCornerCompletionBlock)completion;

@end
