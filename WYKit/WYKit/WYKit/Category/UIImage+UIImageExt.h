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


/**
 *  图像模糊处理
 */
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;


@end
