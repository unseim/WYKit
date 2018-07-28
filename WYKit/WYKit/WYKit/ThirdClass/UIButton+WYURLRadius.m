//
//  UIButton+WYURLRadius.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UIButton+WYURLRadius.h"
//  依赖于 YYKit中的 YYWebImage   开发者可根据需求自行更换
#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYKit.h>
#else
#import "YYKit.h"
#endif

@implementation UIButton (WYURLRadius)


- (void)setImageWithCornerRadius:(CGFloat)radius
                        imageURL:(NSURL *)imageURL
                     placeholder:(UIImage *)placeholder
                            size:(CGSize)size
                        forState:(UIControlState)state
{
    [self setImageWithWYRadius:WYRadiusMake(radius, radius, radius, radius)
                      imageURL:imageURL
                   placeholder:placeholder
                   borderColor:nil
                   borderWidth:0
               backgroundColor:nil
                   contentMode:UIViewContentModeScaleAspectFill
                          size:size
                      forState:state];
}

- (void)setImageWithWYRadius:(WYRadius)radius
                    imageURL:(NSURL *)imageURL
                 placeholder:(UIImage *)placeholder
                        size:(CGSize)size
                    forState:(UIControlState)state
{
    [self setImageWithWYRadius:radius
                      imageURL:imageURL
                   placeholder:placeholder
                   borderColor:nil
                   borderWidth:0
               backgroundColor:nil
                   contentMode:UIViewContentModeScaleAspectFill
                          size:size
                      forState:state];
}


- (void)setImageWithCornerRadius:(CGFloat)radius
                        imageURL:(NSURL *)imageURL
                     placeholder:(UIImage *)placeholder
                     contentMode:(UIViewContentMode)contentMode
                            size:(CGSize)size
                        forState:(UIControlState)state
{
    [self setImageWithWYRadius:WYRadiusMake(radius, radius, radius, radius)
                      imageURL:imageURL
                   placeholder:placeholder
                   borderColor:nil
                   borderWidth:0
               backgroundColor:nil
                   contentMode:contentMode
                          size:size
                      forState:state];
}

- (void)setImageWithWYRadius:(WYRadius)radius
                    imageURL:(NSURL *)imageURL
                 placeholder:(UIImage *)placeholder
                 contentMode:(UIViewContentMode)contentMode
                        size:(CGSize)size
                    forState:(UIControlState)state
{
    [self setImageWithWYRadius:radius
                      imageURL:imageURL
                   placeholder:placeholder
                   borderColor:nil
                   borderWidth:0
               backgroundColor:nil
                   contentMode:contentMode
                          size:size
                      forState:state];
}

- (void)setImageWithWYRadius:(WYRadius)radius
                    imageURL:(NSURL *)imageURL
                 placeholder:(UIImage *)placeholder
                 borderColor:(UIColor *)borderColor
                 borderWidth:(CGFloat)borderWidth
             backgroundColor:(UIColor *)backgroundColor
                 contentMode:(UIViewContentMode)contentMode
                        size:(CGSize)size
                    forState:(UIControlState)state
{
    NSString *transformKey =  [NSString stringWithFormat:@"%@%@%.1f%@%li%@", NSStringFromWYRadius(radius), borderColor.description, borderWidth, backgroundColor.description, (long)contentMode,NSStringFromCGSize(size)];
    
    NSString *transformImageKey = [[YYWebImageManager sharedManager] cacheKeyForURL:imageURL];
    UIImage *cacheImage = [[YYWebImageManager sharedManager].cache getImageForKey:transformImageKey];
    
    if (cacheImage) {
        [self setImage:cacheImage forState:state];
        return;
    }
    
    NSString *imageKey = [[YYWebImageManager sharedManager] cacheKeyForURL:imageURL];
    cacheImage = [[YYWebImageManager sharedManager].cache getImageForKey:imageKey];
    
    if (cacheImage) {
        cacheImage = [UIImage setWYRadius:radius image:cacheImage size:size borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor withContentMode:contentMode];
        [self setImage:cacheImage forState:state];
        return;
    }
    
    UIImage *placeholderImage;
    if (placeholder || borderWidth > 0 || backgroundColor) {
        placeholderImage = [[YYWebImageManager sharedManager].cache getImageForKey:transformKey];
        if (!placeholderImage) {
            placeholderImage = [UIImage setWYRadius:radius image:placeholder size:size borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor withContentMode:contentMode];
            [[YYWebImageManager sharedManager].cache setImage:placeholderImage forKey:transformKey];
        }
    }
    
    
    [self setImageWithURL:imageURL
                 forState:state
              placeholder:placeholderImage
                  options:kNilOptions
                 progress:nil
                transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url)
     {
         [[YYWebImageManager sharedManager].cache setImage:image forKey:imageKey];
         UIImage *currentImage = [UIImage setWYRadius:radius
                                                image:image
                                                 size:size
                                          borderColor:borderColor
                                          borderWidth:borderWidth
                                      backgroundColor:backgroundColor
                                      withContentMode:contentMode];
         return currentImage;
     } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
         
     }];
}

@end
