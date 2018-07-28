//
//  UIButton+WYURLRadius.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>
#import "UIImage+WYRadius.h"

@interface UIButton (WYURLRadius)

/** 设置圆角背景图，默认 UIViewContentModeScaleAspectFill 模式 */
- (void)setImageWithCornerRadius:(CGFloat)radius
                        imageURL:(NSURL *)imageURL
                     placeholder:(UIImage *)placeholder
                            size:(CGSize)size
                        forState:(UIControlState)state;

/** 设置圆角背景图，默认 UIViewContentModeScaleAspectFill 模式 */
- (void)setImageWithWYRadius:(WYRadius)radius
                    imageURL:(NSURL *)imageURL
                 placeholder:(UIImage *)placeholder
                        size:(CGSize)size
                    forState:(UIControlState)state;

/** 设置 contentMode 模式的圆角背景图 */
- (void)setImageWithCornerRadius:(CGFloat)radius
                        imageURL:(NSURL *)imageURL
                     placeholder:(UIImage *)placeholder
                     contentMode:(UIViewContentMode)contentMode
                            size:(CGSize)size
                        forState:(UIControlState)state;

/** 设置 contentMode 模式的圆角背景图 */
- (void)setImageWithWYRadius:(WYRadius)radius
                    imageURL:(NSURL *)imageURL
                 placeholder:(UIImage *)placeholder
                 contentMode:(UIViewContentMode)contentMode
                        size:(CGSize)size
                    forState:(UIControlState)state;

/** 配置所有属性配置圆角背景图 */
- (void)setImageWithWYRadius:(WYRadius)radius
                    imageURL:(NSURL *)imageURL
                 placeholder:(UIImage *)placeholder
                 borderColor:(UIColor *)borderColor
                 borderWidth:(CGFloat)borderWidth
             backgroundColor:(UIColor *)backgroundColor
                 contentMode:(UIViewContentMode)contentMode
                        size:(CGSize)size
                    forState:(UIControlState)state;



@end
