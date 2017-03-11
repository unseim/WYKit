//
//  UIImageView+Base64Image.m
//  WYKit
//
//  Created by 汪年成 on 17/2/25.
//  Copyright © 2017年 之静之初. All rights reserved.
//

#import "UIImageView+Base64Image.h"
#import <YYKit/UIImageView+YYWebImage.h>
//  依赖于YYKit中的 YYWebImage   开发者可根据需求自行更换

@implementation UIImageView (Base64Image)

//  根据图片下载地址或者二进制字符串 设置图片
- (void)setImageWithURLString:(NSString *)url
             placeholderImage:(UIImage *)image
{
    if ([[url substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"http"] ) {
        
        /*
        [self setImageWithURL:[NSURL URLWithString:url] placeholder:image options:YYWebImageOptionIgnoreFailedURL completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            
            //  图片加载完要做的事情
            
         
            
        }];
        */
        
        [self setImageWithURL:[NSURL URLWithString:url] placeholder:image];
        
        
    } else {
        //  二进制显示
        /*服务器返回：例如
         data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAIAAACRXR/mAAAABnRSTlMAAAAAAABupgeRAAAAhElEQVRYhe3Y0QmAIBhF4YwGaZRGaNRGaJRGaYEyTj/RfTjnVYQPBRXbuh9DXuPfgOtkkWSRZJFkkUJZU3H+tsx3Q5VrLXS1ZJFkkWSRZJFkkWSRZJFkkUJZLfPH5vktX3mtv54buomySLJIskihrNBTvvWHP0V37oDQTZRFkkWSRQplnQDfEjVVBe3tAAAAAElFTkSuQmCC
         */
        NSArray *imageArray = [url componentsSeparatedByString:@","];
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imageArray[1] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        self.image = [UIImage imageWithData:imageData];
    }
    
}




//  UIImage -> Base64图片
- (NSString *)stringWithimageBase64URL:(UIImage *)image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
    
}

- (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

@end
