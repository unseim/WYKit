//
//  UIImage+RemoteSize.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//


#import <UIKit/UIKit.h>
typedef void (^UIImageSizeBlock) (NSString* imgURL, CGSize size);

@interface UIImage (RemoteSize)

/** 根据图像 URL 获取尺寸 */
+ (void)requestRemoteSize:(NSString *)url
               completion:(UIImageSizeBlock)completion;

/** 判断文件类型 */
+ (NSString *)contentTypeForImageData:(NSData *)data;

@end
