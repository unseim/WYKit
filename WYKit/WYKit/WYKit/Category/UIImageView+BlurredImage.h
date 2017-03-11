//
//  UIImageView+BlurredImage.h
//  WYKit
//
//  Created by 汪年成 on 17/2/6.
//  Copyright © 2017年 之静之初. All rights reserved.
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
