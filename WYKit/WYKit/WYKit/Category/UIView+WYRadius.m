//
//  UIView+WYRadius.m
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//
#import "UIView+WYRadius.h"
#import <objc/runtime.h>

static NSOperationQueue *wy_operationQueue;
static char wy_operationKey;

@implementation UIView (RoundedCorner)

- (void)setImageWithCornerRadius:(CGFloat)radius image:(UIImage *)image {
    [self setImageWithCornerRadius:radius image:image borderColor:nil borderWidth:0 backgroundColor:nil contentMode:UIViewContentModeScaleAspectFill];
}

- (void)setImageWithWYRadius:(WYRadius)radius image:(UIImage *)image {
    [self setImageWithWYRadius:radius image:image borderColor:nil borderWidth:0 backgroundColor:nil contentMode:UIViewContentModeScaleAspectFill];
}

- (void)setImageWithCornerRadius:(CGFloat)radius image:(UIImage *)image contentMode:(UIViewContentMode)contentMode {
    [self setImageWithCornerRadius:radius image:image borderColor:nil borderWidth:0 backgroundColor:nil contentMode:contentMode];
}

- (void)setImageWithWYRadius:(WYRadius)radius image:(UIImage *)image contentMode:(UIViewContentMode)contentMode {
    [self setImageWithWYRadius:radius image:image borderColor:nil borderWidth:0 backgroundColor:nil contentMode:contentMode];
}

- (void)setImageWithCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor {
    [self setImageWithCornerRadius:radius image:nil borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor contentMode:UIViewContentModeScaleAspectFill];
}

- (void)setImageWithWYRadius:(WYRadius)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor {
    [self setImageWithWYRadius:radius image:nil borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor contentMode:UIViewContentModeScaleAspectFill];
}

- (void)setImageWithCornerRadius:(CGFloat)radius image:(UIImage *)image borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor contentMode:(UIViewContentMode)contentMode {
    [self setImageWithWYRadius:WYRadiusMake(radius, radius, radius, radius) image:image borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor contentMode:contentMode];
}

+ (void)load {
    wy_operationQueue = [[NSOperationQueue alloc] init];
}

- (NSOperation *)wy_getOperation {
    id operation = objc_getAssociatedObject(self, &wy_operationKey);
    return operation;
}

- (void)wy_setImageWithOperation:(NSOperation *)operation {
    objc_setAssociatedObject(self, &wy_operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)wy_cancelOperation {
    NSOperation *operation = [self wy_getOperation];
    [operation cancel];
    [self wy_setImageWithOperation:nil];
}

- (void)setImageWithWYRadius:(WYRadius)radius image:(UIImage *)image borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor contentMode:(UIViewContentMode)contentMode {
    [self wy_cancelOperation];
    
    [self setImageWithWYRadius:radius image:image borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor contentMode:contentMode size:CGSizeZero forState:UIControlStateNormal completion:nil];
}

- (void)setImageWithWYRadius:(WYRadius)radius image:(UIImage *)image borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor contentMode:(UIViewContentMode)contentMode size:(CGSize)size forState:(UIControlState)state completion:(WYRoundedCornerCompletionBlock)completion {
    
    __block CGSize _size = size;
    
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        if ([[weakSelf wy_getOperation] isCancelled]) return;
        
        if (CGSizeEqualToSize(_size, CGSizeZero)) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _size = weakSelf.bounds.size;
            });
        }
        CGSize pixelSize = CGSizeMake(pixel(_size.width), pixel(_size.height));
        UIImage *currentImage = [UIImage setWYRadius:radius image:(UIImage *)image size:pixelSize borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor withContentMode:contentMode];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            __strong typeof(weakSelf) self = weakSelf;
            if ([[self wy_getOperation] isCancelled]) return;
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
            if (completion) completion(currentImage);
        }];
    }];
    
    [self wy_setImageWithOperation:blockOperation];
    [wy_operationQueue addOperation:blockOperation];
}

static inline CGFloat pixel(CGFloat num) {
    CGFloat unit = 1.0 / [UIScreen mainScreen].scale;
    CGFloat remain = fmod(num, unit);
    return num - remain + (remain >= unit / 2.0? unit: 0);
}

@end
