//
//  UIView+WYRadius.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>
#import "UIImage+WYRadius.h"

@interface UIView (RoundedCorner)

typedef void (^WYRoundedCornerCompletionBlock)(UIImage * image);


/** 设置圆角 */
- (void)setCornerRadius:(CGFloat)radius;

/** 设置圆角 */
- (void)setWYRadius:(WYRadius)radius;



/** 设置边框 */
- (void)setBorderColor:(UIColor *)borderColor
           borderWidth:(CGFloat)borderWidth;



/** 设置圆角边框 */
- (void)setCornerRadius:(CGFloat)radius
            borderColor:(UIColor *)borderColor
            borderWidth:(CGFloat)borderWidth;

/** 设置圆角边框 */
- (void)setWYRadius:(WYRadius)radius
        borderColor:(UIColor *)borderColor
        borderWidth:(CGFloat)borderWidth;



/** 配置所有属性配置圆角背景图 */
- (void)setWYRadius:(WYRadius)radius
              image:(UIImage *)image
        borderColor:(UIColor *)borderColor
        borderWidth:(CGFloat)borderWidth
    backgroundColor:(UIColor *)backgroundColor
        contentMode:(UIViewContentMode)contentMode
               size:(CGSize)size
           forState:(UIControlState)state
         completion:(WYRoundedCornerCompletionBlock)completion;





@end
