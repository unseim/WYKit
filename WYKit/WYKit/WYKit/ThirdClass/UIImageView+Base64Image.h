//
//  UIImageView+Base64Image.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
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
