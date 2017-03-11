//
//  UIImageView+Base64Image.h
//  WYKit
//
//  Created by 汪年成 on 17/2/25.
//  Copyright © 2017年 之静之初. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Base64Image)
/**
 *  根据服务器返回的图片是 Base64图片还是 正常的Url加载网络图片
 *
 *  @param url   服务器返回的URL (Base直接填写)
 *  @param image 加载前显示的默认图片
 */
- (void)setImageWithURLString:(NSString *)url
             placeholderImage:(UIImage *)image;

/**
 *  UIImage -> Base64图片
 *
 */
- (NSString *)stringWithimageBase64URL:(UIImage *)image;


@end
