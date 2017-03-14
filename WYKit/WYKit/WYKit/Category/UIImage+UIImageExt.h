//
//  UIImage+UIImageExt.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageExt)
/**
 *  图片压缩
 *  @param targetSize  压缩的大小
 */
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;


/**
 *  本地图片毛玻璃效果处理
 *
 *  @param image  UIImage类型
 *  @param radius 虚化参数
 *
 *  @return 虚化后的UIImage
 */
+ (UIImage *)imageFilterWith:(UIImage *)image andRadius:(CGFloat)radius;

/**
 *  自由拉伸一张图片
 *
 *  @param name 图片名字
 *  @param left 左边开始位置比例  值范围0-1
 *  @param top  上边开始位置比例  值范围0-1
 *
 *  @return 拉伸后的Image
 */
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;


/**
 *  根据颜色和大小获取Image
 *
 *  @param color 颜色
 *  @param size  大小
 *
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


/**
 *  根据图片和颜色返回一张加深颜色以后的图片
 */
+ (UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor;


/**
 *  自由改变Image的大小
 *
 *  @param size 目的大小
 *
 *  @return 修改后的Image
 */
- (UIImage *)cropImageWithSize:(CGSize)size;


/** 图像模糊处理 */
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;


/**
 *  返回一张加水印的图片
 *
 *  @param bg   被加水印的图片
 *  @param logo 即将添加的图片
 *
 *  @return 制作完毕的水印图片
 */

+ (instancetype)waterImageWithBackground:(NSString *)bg
                                    logo:(NSString *)logo;


/**
 *  返回带边框的圆环形图
 *
 *  @param name        图片的名字
 *  @param borderWidth 圆环的线宽
 *  @param borderColor 圆环的颜色
 *
 *  @return 带边框的圆形图
 */
+ (instancetype)circleImageWithName:(NSString *)name
                        borderWidth:(CGFloat)borderWidth
                        borderColor:(UIColor *)borderColor;


/** 根据当前图像，和指定的尺寸，异步生成圆角图像并且返回 */
- (void)cornerImageWithSize:(CGSize)size
                     fillColor:(UIColor *)fillColor
                    completion:(void (^)(UIImage *image))completion;

/** 合并两个图片 */
+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;


@end
