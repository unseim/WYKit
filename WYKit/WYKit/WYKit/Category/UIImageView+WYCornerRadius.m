//
//  UIImageView+WYCornerRadius.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UIImageView+WYCornerRadius.h"
#import <objc/runtime.h>

const char kProcessedImage;

@interface UIImageView ()
@property (nonatomic, assign) CGFloat wyRadius;
@property (nonatomic, assign) UIRectCorner roundingCorners;
@property (nonatomic, assign) CGFloat wyBorderWidth;
@property (nonatomic, strong) UIColor *wyBorderColor;
@property (nonatomic, assign) BOOL wyHadAddObserver;
@property (nonatomic, assign) BOOL wyIsRounding;
@end


@implementation UIImageView (WYCornerRadius)

//  初始化方法 切成圆形图片
- (instancetype)initWithRoundingRectImageView {
    self = [super init];
    if (self) {
        [self cornerRadiusRoundingRect];
    }
    return self;
}

//  初始化 切图片圆角的半径 和 方向
- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius
                             rectCornerType:(UIRectCorner)rectCornerType
{
    self = [super init];
    if (self) {
        [self cornerRadiusAdvance:cornerRadius rectCornerType:rectCornerType];
    }
    return self;
}

//  给图片加边框
- (void)attachBorderWidth:(CGFloat)width
                    color:(UIColor *)color {
    self.wyBorderWidth = width;
    self.wyBorderColor = color;
}


#pragma mark - Kernel
/**
 * @brief clip the cornerRadius with image, UIImageView must be setFrame before, no off-screen-rendered
 */
- (void)wy_cornerRadiusWithImage:(UIImage *)image
                    cornerRadius:(CGFloat)cornerRadius
                  rectCornerType:(UIRectCorner)rectCornerType
{
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (nil == currentContext) {
        return;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];
    [self drawBorder:cornerPath];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (processedImage) {
        objc_setAssociatedObject(processedImage, &kProcessedImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.image = processedImage;
}

/**
 * @brief clip the cornerRadius with image, draw the backgroundColor you want, UIImageView must be setFrame before, no off-screen-rendered, no Color Blended layers
 */
- (void)wy_cornerRadiusWithImage:(UIImage *)image
                    cornerRadius:(CGFloat)cornerRadius
                  rectCornerType:(UIRectCorner)rectCornerType
                 backgroundColor:(UIColor *)backgroundColor
{
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (nil == currentContext) {
        return;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    UIBezierPath *backgroundRect = [UIBezierPath bezierPathWithRect:self.bounds];
    [backgroundColor setFill];
    [backgroundRect fill];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];
    [self drawBorder:cornerPath];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (processedImage) {
        objc_setAssociatedObject(processedImage, &kProcessedImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.image = processedImage;
}


//  切成指定圆角的半径 和 方向 的图片
- (void)cornerRadiusAdvance:(CGFloat)cornerRadius
             rectCornerType:(UIRectCorner)rectCornerType
{
    self.wyRadius = cornerRadius;
    self.roundingCorners = rectCornerType;
    self.wyIsRounding = NO;
    if (!self.wyHadAddObserver) {
        [[self class] swizzleDealloc];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.wyHadAddObserver = YES;
    }
    //Xcode 8 xib 删除了控件的Frame信息，需要主动创造
    [self layoutIfNeeded];
}


//  切成圆形图片
- (void)cornerRadiusRoundingRect
{
    self.wyIsRounding = YES;
    if (!self.wyHadAddObserver) {
        [[self class] swizzleDealloc];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.wyHadAddObserver = YES;
    }
    //Xcode 8 xib 删除了控件的Frame信息，需要主动创造
    [self layoutIfNeeded];
}

#pragma mark - Private
- (void)drawBorder:(UIBezierPath *)path {
    if (0 != self.wyBorderWidth && nil != self.wyBorderColor) {
        [path setLineWidth:2 * self.wyBorderWidth];
        [self.wyBorderColor setStroke];
        [path stroke];
    }
}

- (void)zy_dealloc {
    if (self.wyHadAddObserver) {
        [self removeObserver:self forKeyPath:@"image"];
    }
    [self zy_dealloc];
}

- (void)validateFrame {
    if (self.frame.size.width == 0) {
        [self.class swizzleLayoutSubviews];
    }
}

+ (void)swizzleMethod:(SEL)oneSel anotherMethod:(SEL)anotherSel {
    Method oneMethod = class_getInstanceMethod(self, oneSel);
    Method anotherMethod = class_getInstanceMethod(self, anotherSel);
    method_exchangeImplementations(oneMethod, anotherMethod);
}

+ (void)swizzleDealloc {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:NSSelectorFromString(@"dealloc") anotherMethod:@selector(zy_dealloc)];
    });
}

+ (void)swizzleLayoutSubviews {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(layoutSubviews) anotherMethod:@selector(zy_LayoutSubviews)];
    });
}

- (void)zy_LayoutSubviews {
    [self zy_LayoutSubviews];
    if (self.wyIsRounding) {
        [self wy_cornerRadiusWithImage:self.image cornerRadius:self.frame.size.width/2 rectCornerType:UIRectCornerAllCorners];
    } else if (0 != self.wyRadius && 0 != self.roundingCorners && nil != self.image) {
        [self wy_cornerRadiusWithImage:self.image cornerRadius:self.wyRadius rectCornerType:self.roundingCorners];
    }
}

#pragma mark - KVO for .image
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"]) {
        UIImage *newImage = change[NSKeyValueChangeNewKey];
        if ([newImage isMemberOfClass:[NSNull class]]) {
            return;
        } else if ([objc_getAssociatedObject(newImage, &kProcessedImage) intValue] == 1) {
            return;
        }
        [self validateFrame];
        if (self.wyIsRounding) {
            [self wy_cornerRadiusWithImage:newImage cornerRadius:self.frame.size.width/2 rectCornerType:UIRectCornerAllCorners];
        } else if (0 != self.wyRadius && 0 != self.roundingCorners && nil != self.image) {
            [self wy_cornerRadiusWithImage:newImage cornerRadius:self.wyRadius rectCornerType:self.roundingCorners];
        }
    }
}

#pragma mark property
- (CGFloat)wyBorderWidth {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setWyBorderWidth:(CGFloat)wyBorderWidth {
    objc_setAssociatedObject(self, @selector(wyBorderWidth), @(wyBorderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)wyBorderColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWyBorderColor:(UIColor *)wyBorderColor {
    objc_setAssociatedObject(self, @selector(wyBorderColor), wyBorderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)wyHadAddObserver {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setWyHadAddObserver:(BOOL)wyHadAddObserver {
    objc_setAssociatedObject(self, @selector(wyHadAddObserver), @(wyHadAddObserver), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)wyIsRounding {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setWyIsRounding:(BOOL)wyIsRounding {
    objc_setAssociatedObject(self, @selector(wyIsRounding), @(wyIsRounding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIRectCorner)roundingCorners {
    return [objc_getAssociatedObject(self, _cmd) unsignedLongValue];
}

- (void)setRoundingCorners:(UIRectCorner)roundingCorners {
    objc_setAssociatedObject(self, @selector(roundingCorners), @(roundingCorners), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)wyRadius {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setWyRadius:(CGFloat)wyRadius {
    objc_setAssociatedObject(self, @selector(wyRadius), @(wyRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end

