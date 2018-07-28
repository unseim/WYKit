//
//  UIImage+WaterMark.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface UIImage (WaterMark)

typedef NS_ENUM (NSUInteger, WYWatermarkPositon) {
    
	WYWatermarkPositonTop         = 0,
	WYWatermarkPositonBottom      = 1 << 0,
	WYWatermarkPositonTopLeft     = 1 << 1,
	WYWatermarkPositonTopRight    = 1 << 2,
	WYWatermarkPositonBottomLeft  = 1 << 3,
    WYWatermarkPositonBottomRight = 1 << 4,
    
};


/**
 *  使用文字制作水印
 *  @param image      要添加水印的图片
 *  @param attrString 用来做水印的富文本
 *  @return 添加水印后的图片(默认水印在右下角,距离左边和下边各为5点)
 */
+ (instancetype)imageWithUIImage:(UIImage *)image
                 watermarkOfText:(NSAttributedString *)attrString;

/** 同上,position参数用来设置水印的位置,默认边距都为5 */
+ (instancetype)imageWithUIImage:(UIImage *)image
                 watermarkOfText:(NSAttributedString *)attrString
                        position:(WYWatermarkPositon)position;

/** 同上,offset参数用来调整水印的偏移 */
+ (instancetype)imageWithUIImage:(UIImage *)image
                 watermarkOfText:(NSAttributedString *)attrString
                        position:(WYWatermarkPositon)position
                          offset:(CGPoint)offset;

- (instancetype)addWatermarkWithText:(NSAttributedString *)attrString;

- (instancetype)addWatermarkWithText:(NSAttributedString *)attrString
                            position:(WYWatermarkPositon)position;

- (instancetype)addWatermarkWithText:(NSAttributedString *)attrString
                            position:(WYWatermarkPositon)position
                              offset:(CGPoint)offset;

/**
 *  使用图片制作水印
 *  @param image          要添加水印的图片
 *  @param waterMaskImage 用来做水印的图片
 *  @return 添加水印后的图片(默认水印在右下角,与右边和下边距离各为5点)
 */
+ (instancetype)imageWithUIImage:(UIImage *)image
                watermarkOfImage:(UIImage *)waterMaskImage;

/** 同上,position参数用来设置水印的位置,默认边距都为5 */
+ (instancetype)imageWithUIImage:(UIImage *)image
                watermarkOfImage:(UIImage *)waterMaskImage
                        position:(WYWatermarkPositon) postion;

/** 同上,offset参数用来调整水印的位置 */
+ (instancetype)imageWithUIImage:(UIImage *)image
                watermarkOfImage:(UIImage *)waterMaskImage
                        position:(WYWatermarkPositon) postion
                          offset:(CGPoint)offset;


- (instancetype)addWatermarkWithImage:(UIImage *)image;

- (instancetype)addWatermarkWithImage:(UIImage *)waterMaskImage
                             position:(WYWatermarkPositon) postion;

- (instancetype)addWatermarkWithImage:(UIImage *)waterMaskImage
                             position:(WYWatermarkPositon) postion
                               offset:(CGPoint)offset;


@end
