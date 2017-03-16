//
//  UIView+WYKit.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface UIView (WYKit)

@property (nonatomic,assign) CGFloat cornerRad;

@property (nonatomic,assign)CGFloat Cy;

@property (nonatomic,assign)CGFloat Cx;

@property (nonatomic,assign)CGFloat X;

@property (nonatomic,assign)CGFloat Y;

@property (nonatomic,assign)CGFloat Sh;

@property (nonatomic,assign)CGSize size;

@property (nonatomic,assign)CGFloat Sw;




/** 根据图片URL获取图片尺寸 */
+ (CGSize)getImageSizeWithURL:(id)imageURL;

/** 获取PNG图片的大小 */
+ (CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest *)request;

/** 获取GIF图片的大小 */
+ (CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest *)request;

/** 获取JPG图片的大小 */
+ (CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest *)request;

/** 获取屏幕截图 */
+ (UIImage *)screenShotWithView:(UIView *)view;


@end
