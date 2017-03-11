//
//  UIView+ImageSize.h
//  WYKit
//
//  Created by 汪年成 on 16/12/23.
//  Copyright © 2016年 之静之初. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ImageSize)

/**
 *  根据图片URL获取图片尺寸
 */
+ (CGSize)getImageSizeWithURL:(id)imageURL;

/**
 *  获取PNG图片的大小
 */
+ (CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest *)request;

/**
 *  获取GIF图片的大小
 */
+ (CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest *)request;

/**
 *  获取JPG图片的大小
 */
+ (CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest *)request;


@end
