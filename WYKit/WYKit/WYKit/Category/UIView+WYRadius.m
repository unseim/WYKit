//
//  UIView+WYRadius.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//
#import "UIView+WYRadius.h"
#import <objc/runtime.h>

static NSOperationQueue *operationQueue;
static char operationKey;
@implementation UIView (RoundedCorner)


/** 设置圆角 */
- (void)setCornerRadius:(CGFloat)radius
{
    [self setWYRadius:WYRadiusMake(radius, radius, radius, radius)
                image:nil
          borderColor:nil
          borderWidth:0
      backgroundColor:nil
          contentMode:UIViewContentModeScaleAspectFill];
}

/** 设置圆角 */
- (void)setWYRadius:(WYRadius)radius
{
    [self setWYRadius:radius
                image:nil
          borderColor:nil
          borderWidth:0
      backgroundColor:self.backgroundColor
          contentMode:UIViewContentModeScaleAspectFill];
}

/** 设置边框 */
- (void)setBorderColor:(UIColor *)borderColor
           borderWidth:(CGFloat)borderWidth
{
    [self setWYRadius:WYRadiusMake(0, 0, 0, 0)
                image:nil
          borderColor:borderColor
          borderWidth:borderWidth
      backgroundColor:self.backgroundColor
          contentMode:UIViewContentModeScaleAspectFill];
}


/**设置圆角边框*/
- (void)setCornerRadius:(CGFloat)radius
            borderColor:(UIColor *)borderColor
            borderWidth:(CGFloat)borderWidth
{
    [self setWYRadius:WYRadiusMake(radius, radius, radius, radius)
                image:nil
          borderColor:borderColor
          borderWidth:borderWidth
      backgroundColor:self.backgroundColor
          contentMode:UIViewContentModeScaleAspectFill];
}

/** 设置圆角边框 */
- (void)setWYRadius:(WYRadius)radius
        borderColor:(UIColor *)borderColor
        borderWidth:(CGFloat)borderWidth
{
    [self setWYRadius:radius
                image:nil
          borderColor:borderColor
          borderWidth:borderWidth
      backgroundColor:self.backgroundColor
          contentMode:UIViewContentModeScaleAspectFill];
}




+ (void)load
{
    operationQueue = [[NSOperationQueue alloc] init];
}

- (NSOperation *)getOperation
{
    id operation = objc_getAssociatedObject(self, &operationKey);
    return operation;
}

- (void)setCornerRadiusWithOperation:(NSOperation *)operation {
    objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cancelOperation
{
    NSOperation *operation = [self getOperation];
    [operation cancel];
    [self setCornerRadiusWithOperation:nil];
}

- (void)setWYRadius:(WYRadius)radius
              image:(UIImage *)image
        borderColor:(UIColor *)borderColor
        borderWidth:(CGFloat)borderWidth
    backgroundColor:(UIColor *)backgroundColor
        contentMode:(UIViewContentMode)contentMode
{
    [self cancelOperation];
    
    [self setWYRadius:radius
                image:image
          borderColor:borderColor
          borderWidth:borderWidth
      backgroundColor:backgroundColor
          contentMode:contentMode
                 size:CGSizeZero
             forState:UIControlStateNormal
           completion:nil];
}


- (void)setWYRadius:(WYRadius)radius
              image:(UIImage *)image
        borderColor:(UIColor *)borderColor
        borderWidth:(CGFloat)borderWidth
    backgroundColor:(UIColor *)backgroundColor
        contentMode:(UIViewContentMode)contentMode
               size:(CGSize)size
           forState:(UIControlState)state
         completion:(WYRoundedCornerCompletionBlock)completion
{
    
    __block CGSize _size = size;
    
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        if ([[weakSelf getOperation] isCancelled]) return;
        
        if (CGSizeEqualToSize(_size, CGSizeZero)) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _size = weakSelf.bounds.size;
            });
        }
        CGSize pixelSize = CGSizeMake(pixel(_size.width), pixel(_size.height));
        UIImage *currentImage = [UIImage setWYRadius:radius image:(UIImage *)image size:pixelSize borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor withContentMode:contentMode];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            __strong typeof(weakSelf) self = weakSelf;
            if ([[self getOperation] isCancelled]) return;
            self.frame = CGRectMake(pixel(self.frame.origin.x), pixel(self.frame.origin.y), pixelSize.width, pixelSize.height);
            if ([self isKindOfClass:[UIImageView class]]) {
                ((UIImageView *)self).image = currentImage;
            } else if ([self isKindOfClass:[UIButton class]] && image) {
                [((UIButton *)self) setBackgroundImage:currentImage forState:state];
            } else if ([self isKindOfClass:[UILabel class]]) {
                self.layer.backgroundColor = [UIColor colorWithPatternImage:currentImage].CGColor;
            } else {
                self.layer.contents = (__bridge id _Nullable)(currentImage.CGImage);
            }
            self.layer.masksToBounds = YES;
            self.clipsToBounds = YES;
            if (completion) completion(currentImage);
        }];
    }];
    
    [self setCornerRadiusWithOperation:blockOperation];
    [operationQueue addOperation:blockOperation];
}


static inline CGFloat pixel(CGFloat num) {
    CGFloat unit = 1.0 / [UIScreen mainScreen].scale;
    CGFloat remain = fmod(num, unit);
    return num - remain + (remain >= unit / 2.0? unit: 0);
}

@end
