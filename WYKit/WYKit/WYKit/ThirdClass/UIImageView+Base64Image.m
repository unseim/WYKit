//
//  UIImageView+Base64Image.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UIImageView+Base64Image.h"
//  依赖于YYKit中的 YYWebImage   开发者可根据需求自行更换
#if __has_include(<YYKit/UIImageView+YYWebImage.h>)
#import <YYKit/UIImageView+YYWebImage.h>
#else
#import "UIImageView+YYWebImage.h"
#endif

@implementation UIImageView (Base64Image)

//  根据图片下载地址或者二进制字符串 设置图片
- (void)setImageWithURLString:(NSString *)url
             placeholderImage:(UIImage *)image
{
    if (url == nil || url.length < 1)
    {
        self.image = image;
        return;
    }
    
    if (url.length >= 10 && [[url substringWithRange:NSMakeRange(0, 10)] isEqualToString:@"data:image"])
    {
        //  二进制显示
        /*服务器返回：例如
         data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAIAAACRXR/mAAAABnRSTlMAAAAAAABupgeRAAAAhElEQVRYhe3Y0QmAIBhF4YwGaZRGaNRGaJRGaYEyTj/RfTjnVYQPBRXbuh9DXuPfgOtkkWSRZJFkkUJZU3H+tsx3Q5VrLXS1ZJFkkWSRZJFkkWSRZJFkkUJZLfPH5vktX3mtv54buomySLJIskihrNBTvvWHP0V37oDQTZRFkkWSRQplnQDfEjVVBe3tAAAAAElFTkSuQmCC
         */
        NSArray *imageArray = [url componentsSeparatedByString:@","];
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imageArray[1] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        self.image = [UIImage imageWithData:imageData];
        
    } else
    {
        NSString *encodingUrlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
        NSString *imageUrl = [encodingUrlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [self setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:image];
    }
}


- (void)setImageWithURLString:(NSString *)url
             placeholderImage:(UIImage *)image
                   completion:(void (^)(CGSize))handler
{
    if (url == nil || url.length < 1)
    {
        self.image = image;
        return;
    }
    
    if (url.length >= 10 && [[url substringWithRange:NSMakeRange(0, 10)] isEqualToString:@"data:image"])
    {
        //  二进制显示
        /*服务器返回：例如
         data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAIAAACRXR/mAAAABnRSTlMAAAAAAABupgeRAAAAhElEQVRYhe3Y0QmAIBhF4YwGaZRGaNRGaJRGaYEyTj/RfTjnVYQPBRXbuh9DXuPfgOtkkWSRZJFkkUJZU3H+tsx3Q5VrLXS1ZJFkkWSRZJFkkWSRZJFkkUJZLfPH5vktX3mtv54buomySLJIskihrNBTvvWHP0V37oDQTZRFkkWSRQplnQDfEjVVBe3tAAAAAElFTkSuQmCC
         */
        NSArray *imageArray = [url componentsSeparatedByString:@","];
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imageArray[1] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        self.image = [UIImage imageWithData:imageData];
        handler(self.image.size);
        
    } else
    {
        NSString *encodingUrlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
        NSString *imageUrl = [encodingUrlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [self setImageWithURL:[NSURL URLWithString:imageUrl]
                  placeholder:image
                      options:YYWebImageOptionSetImageWithFadeAnimation
                   completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error)
         {
             handler(image.size);
        }];
    }
}


- (void)setImageWithURLString:(NSString *)url
             placeholderImage:(UIImage *)image
              iamgeCompletion:(void (^)(UIImage *))handler
{
    if (url == nil || url.length < 1)
    {
        self.image = image;
        return;
    }
    
    if (url.length >= 10 && [[url substringWithRange:NSMakeRange(0, 10)] isEqualToString:@"data:image"])
    {
        //  二进制显示
        /*服务器返回：例如
         data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAIAAACRXR/mAAAABnRSTlMAAAAAAABupgeRAAAAhElEQVRYhe3Y0QmAIBhF4YwGaZRGaNRGaJRGaYEyTj/RfTjnVYQPBRXbuh9DXuPfgOtkkWSRZJFkkUJZU3H+tsx3Q5VrLXS1ZJFkkWSRZJFkkWSRZJFkkUJZLfPH5vktX3mtv54buomySLJIskihrNBTvvWHP0V37oDQTZRFkkWSRQplnQDfEjVVBe3tAAAAAElFTkSuQmCC
         */
        NSArray *imageArray = [url componentsSeparatedByString:@","];
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imageArray[1] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        self.image = [UIImage imageWithData:imageData];
        handler(self.image);
        
    } else
    {
        NSString *encodingUrlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
        NSString *imageUrl = [encodingUrlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [self setImageWithURL:[NSURL URLWithString:imageUrl]
                  placeholder:image
                      options:YYWebImageOptionSetImageWithFadeAnimation
                   completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error)
         {
             handler(image);
         }];
    }
}


@end
