//
//  UIImageView+BlurredImage.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

typedef void(^BlurredImageCompletionBlock)(void);

extern CGFloat const BlurredImageDefaultBlurRadius;

@interface UIImageView (BlurredImage)


/**
 *  图片毛玻璃效果
 *
 *  @param image      图片
 *  @param blurRadius 模糊程度
 *  @param completion 图片处理完成回调
 */
- (void)setImageToBlur:(UIImage *)image
            blurRadius:(CGFloat)blurRadius
       completionBlock:(BlurredImageCompletionBlock)completion;


/**
 *  图片毛玻璃效果
 *
 *  @param image      图片
 *  @param blurRadius 模糊程度
 */
- (void)setImageToBlur:(UIImage *)image
       completionBlock:(BlurredImageCompletionBlock)completion;



@end
