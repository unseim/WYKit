//
//  UIImageView+Base64Image.m
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UIImageView+Base64Image.h"
#import <YYKit/UIImageView+YYWebImage.h>
//  依赖于YYKit中的 YYWebImage   开发者可根据需求自行更换

@implementation UIImageView (Base64Image)

//  根据图片下载地址或者二进制字符串 设置图片
- (void)setImageWithURLString:(NSString *)url
             placeholderImage:(UIImage *)image
{
    
    if ([url isEqualToString:@""] || ![[url substringWithRange:NSMakeRange(0, 10)] isEqualToString:@"data:image"])
    {
        
        //  处理链接中的空格
        NSString *URL = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        [self setImageWithURL:[NSURL URLWithString:URL] placeholder:image];
        
        
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


@end
