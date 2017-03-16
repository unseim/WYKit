//
//  UIImage+WYKit.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

/**
 *  水印方向
 */
typedef NS_ENUM(NSUInteger, WYWatermarkDirection) {
    WYWatermarkDirectionTopLeft,        // 左上
    WYWatermarkDirectionTopRight,       // 右上
    WYWatermarkDirectionBottomLeft,     // 左下
    WYWatermarkDirectionBottomRight,    // 右下
    WYWatermarkDirectionCenter,         // 正中
};

@interface UIImage (WYKit)

/** 图片压缩 */
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

/**
 *  本地图片毛玻璃效果处理
 *
 *  @param image  图片
 *  @param blur   虚化程度
 *
 *  @return 虚化后的UIImage
 */
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

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


/** 根据颜色和大小获取Image */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


/** 根据图片和颜色返回一张加深颜色以后的图片 */
+ (UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor;


/** 自由改变Image的大小 */
- (UIImage *)cropImageWithSize:(CGSize)size;


/**
 *  裁剪为带边框的圆环形图
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


/** 将图片裁剪成圆形 */
+ (UIImage *)imageCircleTailorWithImage:(UIImage *)image;

/** 从给定的UIView中截图：UIView转UIImage */
+ (UIImage *)screenshotWithView:(UIView *)view;

/** 直接截屏 */
+ (UIImage *)screencapture;

/** 指定区域位置截取图片 */
- (UIImage *)screenshotWithFrame:(CGRect)frame;

/** 返回一张抗锯齿图片  (本质：在图片生成一个透明为1的像素边框) */
- (UIImage *)imageAntialias;

/** 获得某个像素的颜色 */
- (UIColor *)pixelColorAtLocation:(CGPoint)point;

/** 根据颜色生成图片 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/** 加载最原始的图片 */
+ (UIImage *)imageWithOriginalImageName:(NSString *)imageName;


#pragma mark - 相册操作相关

/**
 *  将图片保存到相册
 *  @param completeBlock 保存成功回调
 *  @param failBlock     保存失败回调
 */
- (void)savedPhotoAlbum:(void(^)())completeBlock failBlock:(void(^)())failBlock;



#pragma mark - 解决应用图片旋转或颠倒的bug


/**
 *  解决应用图片旋转或颠倒的bug
 *      用相机拍摄出来的照片含有EXIF信息，UIImage的imageOrientation属性指的就是EXIF中的orientation信息。
 *      如果我们忽略orientation信息，而直接对照片进行像素处理或者drawInRect等操作，得到的结果是翻转或者旋转90之后的样子。
 *      这是因为我们执行像素处理或者drawInRect等操作之后，    imageOrientaion信息被删除了，imageOrientaion被重设为0，造成照片内容和imageOrientaion不匹配。
 *      所以，在对照片进行处理之前，先将照片旋转到正确的方向，并且返回的imageOrientaion为0。
 *
 *  @return 正常图片
 */
- (UIImage *)fixOrientation;



#pragma mark - 图片水印

/**
 *  给图片添加文字水印
 *
 *  @param text      文字水印
 *  @param direction 水印在图片中的位置
 *  @param fontColor 文字颜色
 *  @param fontPoint 位置中心点
 *  @param marginXY  间距
 *
 *  @return 有水印的图片
 */
- (UIImage *)watermarkWithText:(NSString *)text
                     direction:(WYWatermarkDirection)direction
                     fontColor:(UIColor *)fontColor
                     fontPoint:(CGFloat)fontPoint
                      marginXY:(CGPoint)marginXY;

/**
 *  给图片添加图片水印
 *
 *  @param watermarkImage 图片水印
 *  @param direction      水印在图中的位置
 *  @param waterSize      水印大小
 *  @param marginXY       间距
 *
 *  @return 有水印的图片
 */
- (UIImage *)watermarkWithWatermarkImage:(UIImage *)watermarkImage
                               direction:(WYWatermarkDirection)direction
                           watermarkSize:(CGSize)watermarkSize
                                marginXY:(CGPoint)marginXY;

@end
