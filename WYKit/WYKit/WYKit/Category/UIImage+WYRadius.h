//
//  UIImage+WYRadius.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

struct WYRadius {
    CGFloat topLeftRadius;
    CGFloat topRightRadius;
    CGFloat bottomLeftRadius;
    CGFloat bottomRightRadius;
};
typedef struct WYRadius WYRadius;

static inline WYRadius WYRadiusMake(CGFloat topLeftRadius, CGFloat topRightRadius, CGFloat bottomLeftRadius, CGFloat bottomRightRadius) {
    WYRadius radius;
    radius.topLeftRadius = topLeftRadius;
    radius.topRightRadius = topRightRadius;
    radius.bottomLeftRadius = bottomLeftRadius;
    radius.bottomRightRadius = bottomRightRadius;
    return radius;
}

static inline NSString * NSStringFromWYRadius(WYRadius radius) {
    return [NSString stringWithFormat:@"{%.2f, %.2f, %.2f, %.2f}", radius.topLeftRadius, radius.topRightRadius, radius.bottomLeftRadius, radius.bottomRightRadius];
}

@interface UIImage (RoundedCorner)

- (UIImage *)setRadius:(CGFloat)radius
                  size:(CGSize)size;

- (UIImage *)setRadius:(CGFloat)radius
                  size:(CGSize)size
           contentMode:(UIViewContentMode)contentMode;

+ (UIImage *)setRadius:(CGFloat)radius
                  size:(CGSize)size
           borderColor:(UIColor *)borderColor
           borderWidth:(CGFloat)borderWidth
       backgroundColor:(UIColor *)backgroundColor;

+ (UIImage *)setWYRadius:(WYRadius)radius
                   image:(UIImage *)image
                    size:(CGSize)size
             borderColor:(UIColor *)borderColor
             borderWidth:(CGFloat)borderWidth
         backgroundColor:(UIColor *)backgroundColor
         withContentMode:(UIViewContentMode)contentMode;

@end
