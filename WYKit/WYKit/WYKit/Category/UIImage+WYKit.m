//
//  UIImage+WYKit.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UIImage+WYKit.h"
#import <Accelerate/Accelerate.h>
#import "WYCategoryMacro.h"

WY_RUNTIME_CLASS(UIImage_WYKit)

static const void *completeBlockKey = &completeBlockKey;
static const void *failBlockKey = &failBlockKey;

@interface UIImage ()

@property (nonatomic,copy) void(^completeBlock)(void);

@property (nonatomic,copy) void(^failBlock)(void);

@end

@implementation UIImage (WYKit)

//  图片压缩
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    UIGraphicsEndImageContext();
    return newImage;
}


//  本地图片毛玻璃效果
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}

// 高斯模糊效果
+ (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}



//  生成一张毛玻璃图片
- (UIImage*)blur:(UIImage*)theImage
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return returnImage;
}


//  自由拉伸一张图片
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}


//  根据颜色和大小获取Image
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


//  根据图片和颜色返回一张加深颜色以后的图片
+ (UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor
{
    
    UIGraphicsBeginImageContext(CGSizeMake(baseImage.size.width*2, baseImage.size.height*2));
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width * 2, baseImage.size.height * 2);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    
    [theColor set];
    CGContextFillRect(ctx, area);
    
    CGContextRestoreGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextDrawImage(ctx, area, baseImage.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


//  自由改变Image的大小
- (UIImage *)cropImageWithSize:(CGSize)size
{
    
    float scale = self.size.width/self.size.height;
    CGRect rect = CGRectMake(0, 0, 0, 0);
    
    if (scale > size.width/size.height) {
        
        rect.origin.x = (self.size.width - self.size.height * size.width/size.height)/2;
        rect.size.width  = self.size.height * size.width/size.height;
        rect.size.height = self.size.height;
        
    }else {
        
        rect.origin.y = (self.size.height - self.size.width/size.width * size.height)/2;
        rect.size.width  = self.size.width;
        rect.size.height = self.size.width/size.width * size.height;
        
    }
    
    CGImageRef imageRef   = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return croppedImage;
}


//  返回一张带边框的圆形图
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 1、加载原图
    UIImage *oldImage = [UIImage imageNamed:name];
    
    // 2、开启上下文
    CGFloat imageW = oldImage.size.width + borderWidth * 2;
    CGFloat imageH = oldImage.size.height + borderWidth * 2;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3、取得当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4、设置颜色
    [borderColor set];
    // 5、画大圆
    // 5.1 大圆半径
    CGFloat bigRadius = imageW * 0.5;
    // 5.2 大圆的位置
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
    
    // 6、画小圆
    // 6.1 小圆半径
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 7、裁剪(这一步只有后面的东西才会受影响）
    CGContextClip(ctx);
    
    // 8、画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    // 9、取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 10、结束上下文
    UIGraphicsEndImageContext();
    
    
    return newImage;
}


//  根据当前图像，和指定的尺寸，异步生成圆角图像并且返回
- (void)cornerImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor completion:(void (^)(UIImage *))completion {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSTimeInterval start = CACurrentMediaTime();
        
        // 1. 利用绘图，建立上下文
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        // 2. 设置填充颜色
        [fillColor setFill];
        UIRectFill(rect);
        
        // 3. 利用 贝赛尔路径 `裁切 效果
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        
        [path addClip];
        
        // 4. 绘制图像
        [self drawInRect:rect];
        
        // 5. 取得结果
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        
        // 6. 关闭上下文
        UIGraphicsEndImageContext();
        
        NSLog(@"%f", CACurrentMediaTime() - start);
        
        // 7. 完成回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion != nil) {
                completion(result);
            }
        });
    });
}

//  合并两张图片
+ (UIImage *)mergeImage:(UIImage *)firstImage withImage:(UIImage *)secondImage
{
    CGImageRef firstImageRef = firstImage.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
    CGImageRef secondImageRef = secondImage.CGImage;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    CGSize mergedSize = CGSizeMake(MAX(firstWidth, secondWidth), MAX(firstHeight, secondHeight));
    UIGraphicsBeginImageContext(mergedSize);
    [firstImage drawInRect:CGRectMake(0, 0, firstWidth, firstHeight)];
    [secondImage drawInRect:CGRectMake(0, 0, secondWidth, secondHeight)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//  将图片裁剪成圆形
+ (UIImage *)imageCircleTailorWithImage:(UIImage *)image
{
    // 获取位图上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    
    // 设置裁剪路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    // 裁剪
    [path addClip];
    
    // 将图片绘制到位图上下文中
    [image drawAtPoint:CGPointZero];
    
    // 从位图上下文中输出新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭位图上下文
    UIGraphicsEndImageContext();
    
    // 返回裁剪成功
    return newImage;
}

//  从给定的UIView中截图
+ (UIImage *)screenshotWithView:(UIView *)view
{
    // 开启图形上下文
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0f);
    
    // 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 在新建的图形上下文中渲染view的layer
    [view.layer renderInContext:context];
    
    [[UIColor clearColor] setFill];
    
    // 获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

//  直接截屏
+ (UIImage *)screencapture
{
    return [self screenshotWithView:[UIApplication sharedApplication].keyWindow];
}

//  指定区域位置截取图片
- (UIImage *)screenshotWithFrame:(CGRect)frame
{
    // 创建CGImage
    CGImageRef cgimage = CGImageCreateWithImageInRect(self.CGImage, frame);
    
    // 创建image
    UIImage *newImage=[UIImage imageWithCGImage:cgimage];
    
    // 释放CGImage
    CGImageRelease(cgimage);
    
    return newImage;
}

//  抗锯齿图片
- (UIImage *)imageAntialias
{
    CGFloat border = 1.0f;
    CGRect rect = CGRectMake(border, border, self.size.width - 2 * border, self.size.height - 2 * border);
    
    UIImage *img = nil;
    
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width,rect.size.height));
    [self drawInRect:CGRectMake(-1, -1, self.size.width, self.size.height)];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(self.size);
    [img drawInRect:rect];
    UIImage* antiImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return antiImage;
}

//  获得某个像素的颜色
- (UIColor *)pixelColorAtLocation:(CGPoint)point
{
    UIColor *color = nil;
    CGImageRef inImage = self.CGImage;
    CGContextRef contexRef = [self ARGBBitmapContextFromImage:inImage];
    if (contexRef == NULL) return nil;
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    CGContextDrawImage(contexRef, rect, inImage);
    
    unsigned char* data = CGBitmapContextGetData (contexRef);
    if (data != NULL) {
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    
    CGContextRelease(contexRef);
    
    if (data) { free(data); }
    
    return color;
}

//  根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

//  加载最原始的图片
+ (UIImage *)imageWithOriginalImageName:(NSString *)imageName
{
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

//  将图片保存到相册
- (void)savedPhotoAlbum:(void (^)(void))completeBlock failBlock:(void (^)(void))failBlock
{
    UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    self.completeBlock = completeBlock;
    self.failBlock = failBlock;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    if (!error) {
        if (self.completeBlock != nil) self.completeBlock();
    } else {
        if (self.failBlock != nil) self.failBlock();
    }
    
}

// ********** 模拟成员变量 ********** //
- (void (^)(void))failBlock
{
    return objc_getAssociatedObject(self, failBlockKey);
}

- (void)setFailBlock:(void (^)(void))failBlock
{
    objc_setAssociatedObject(self, failBlockKey, failBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))completeBlock
{
    return objc_getAssociatedObject(self, completeBlockKey);
}

- (void)setCompleteBlock:(void (^)(void))completeBlock
{
    objc_setAssociatedObject(self, completeBlockKey, completeBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - 解决应用图片旋转或颠倒的bug
- (UIImage *)fixOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


#pragma mark - 图片水印
//  给图片添加文字水印
- (UIImage *)watermarkWithText:(NSString *)text
                     direction:(WYWatermarkDirection)direction
                     fontColor:(UIColor *)fontColor
                     fontPoint:(CGFloat)fontPoint
                      marginXY:(CGPoint)marginXY
{
    
    CGSize size = self.size;
    
    CGRect rect = (CGRect){CGPointZero,size};
    
    //新建图片图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //绘制图片
    [self drawInRect:rect];
    
    //绘制文本
    NSDictionary *attr =@{NSFontAttributeName : [UIFont systemFontOfSize:fontPoint],NSForegroundColorAttributeName:fontColor};
    
    CGRect strRect = [self calWidth:text attr:attr direction:direction rect:rect marginXY:marginXY];
    
    [text drawInRect:strRect withAttributes:attr];
    
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束图片图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}


//  给图片添加图片水印
- (UIImage *)watermarkWithWatermarkImage:(UIImage *)watermarkImage
                               direction:(WYWatermarkDirection)direction
                           watermarkSize:(CGSize)watermarkSize
                                marginXY:(CGPoint)marginXY
{
    CGSize size = self.size;
    
    CGRect rect = (CGRect){CGPointZero, size};
    
    //新建图片图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //绘制图片
    [self drawInRect:rect];
    
    //计算水印的rect
    CGSize watermarkImageSize = CGSizeEqualToSize(watermarkSize, CGSizeZero) ? watermarkImage.size : watermarkSize;
    CGRect calRect = [self rectWithRect:rect size:watermarkImageSize direction:direction marginXY:marginXY];
    
    //绘制水印图片
    [watermarkImage drawInRect:calRect];
    
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束图片图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (CGRect)calWidth:(NSString *)str
              attr:(NSDictionary *)attr
         direction:(WYWatermarkDirection)direction
              rect:(CGRect)rect
          marginXY:(CGPoint)marginXY
{
    
    CGSize size =  [str sizeWithAttributes:attr];
    
    CGRect calRect = [self rectWithRect:rect size:size direction:direction marginXY:marginXY];
    
    return calRect;
}

- (CGRect)rectWithRect:(CGRect)rect
                  size:(CGSize)size
             direction:(WYWatermarkDirection)direction
              marginXY:(CGPoint)marginXY
{
    
    CGPoint point = CGPointZero;
    
    // 右上
    if (WYWatermarkDirectionTopRight == direction) point = CGPointMake(rect.size.width - size.width, 0);
    
    // 左下
    if(WYWatermarkDirectionBottomLeft == direction) point = CGPointMake(0, rect.size.height - size.height);
    
    // 右下
    if(WYWatermarkDirectionBottomRight == direction) point = CGPointMake(rect.size.width - size.width, rect.size.height - size.height);
    
    // 正中
    if(WYWatermarkDirectionCenter == direction) point = CGPointMake((rect.size.width - size.width)*.5f, (rect.size.height - size.height)*.5f);
    
    point.x += marginXY.x;
    point.y += marginXY.y;
    
    CGRect calRect = (CGRect){point,size};
    
    return calRect;
}



/**
 *  根据CGImageRef来创建一个ARGBBitmapContext
 */
- (CGContextRef)ARGBBitmapContextFromImage:(CGImageRef) inImage
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    NSInteger             bitmapByteCount;
    NSInteger             bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    if (context == NULL) {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
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

#pragma mark --------生成阴影
+ (UIImage *)creatShadowImageWithOriginalImage:(UIImage *)image
                              andShadowOffset:(CGSize)offset
                                 andBlurWidth:(CGFloat)blurWidth
                                     andAlpha:(CGFloat)Alpha
                                     andColor:(UIColor *)Color
{
    CGFloat Scale = 2;
    
    CGFloat width  = (image.size.width+offset.width+blurWidth*4)*Scale;
    CGFloat height = (image.size.height+offset.height+blurWidth*4)*Scale;
    if(offset.width<0){
        width  = (image.size.width-offset.width+blurWidth*4)*Scale;
    }
    if(offset.height<0){
        height = (image.size.height-offset.height+blurWidth*4)*Scale;
    }
    
    UIView *RootBackView = [[UIView alloc]initWithFrame:CGRectMake(0,0,
                                                                   width,
                                                                   height)];
    RootBackView.backgroundColor = [UIColor clearColor];
    
    UIImageView *ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(blurWidth*2*Scale,
                                                                          blurWidth*2*Scale,
                                                                          image.size.width*Scale,
                                                                          image.size.height*Scale)];
    if(offset.width<0){
        ImageView.frame = CGRectMake((blurWidth*2-offset.width)*Scale,
                                     ImageView.frame.origin.y,
                                     ImageView.frame.size.width,
                                     ImageView.frame.size.height);
    }
    if(offset.height<0){
        ImageView.frame = CGRectMake(ImageView.frame.origin.x,
                                     (blurWidth*2-offset.height)*Scale,
                                     ImageView.frame.size.width,
                                     ImageView.frame.size.height);
    }
    ImageView.backgroundColor = [UIColor clearColor];
    ImageView.layer.shadowOffset = CGSizeMake(offset.width*Scale, offset.height*Scale);
    ImageView.layer.shadowRadius = blurWidth*Scale;
    ImageView.layer.shadowOpacity = Alpha;
    ImageView.layer.shadowColor  = Color.CGColor;
    ImageView.image = image;
    
    [RootBackView addSubview:ImageView];
    
    //ImageView.transform = CGAffineTransformMakeRotation(3.1415926*0.25);
    //ImageView.transform = CGAffineTransformMakeScale(2, 2);
    
    UIImage *newImage = [self imageWithUIView:RootBackView];
    
    return newImage;
}

#pragma mark --------UIView转图片，提前渲染

+ (UIImage *)imageWithUIView:(UIView *)view
{
    //UIGraphicsBeginImageContext(view.bounds.size);
    UIGraphicsBeginImageContext(CGSizeMake(view.bounds.size.width, view.bounds.size.height));
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:ctx];
    
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tImage;
}
@end
