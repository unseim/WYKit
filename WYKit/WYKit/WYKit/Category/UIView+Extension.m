//
//  UIView+Extension.m
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setCornerRad:(CGFloat)cornerRad {
    self.layer.cornerRadius = cornerRad;
    self.layer.masksToBounds = YES;
}

- (CGFloat)cornerRad {
    return self.cornerRad;
}

- (void)setCy:(CGFloat)Cy {
    CGPoint center = self.center;
    center.y = Cy;
    self.center = center;
}

- (CGFloat)Cy {
    return self.center.y;
}

- (void)setCx:(CGFloat)Cx {
    CGPoint center = self.center;
    center.x = Cx;
    self.center = center;
}

- (CGFloat)Cx {
    return self.center.x;
}

- (void)setSh:(CGFloat)Sh {
    CGRect fram = self.frame;
    fram.size.height = Sh;
    self.frame = fram;
}

- (CGFloat)Sh {
    return self.frame.size.height;
}

- (void)setSw:(CGFloat)Sw {
    CGRect fram = self.frame;
    fram.size.width = Sw;
    self.frame = fram;
}

- (CGFloat)Sw {
    return self.frame.size.width;
}

- (CGFloat)X {
    return self.frame.origin.x;
}

- (CGFloat)Y {
    return self.frame.origin.y;
}

- (void)setX:(CGFloat)X {
    CGRect frame = self.frame;
    frame.origin.x = X;
    self.frame = frame;
}

- (void)setY:(CGFloat)Y {
    CGRect frame = self.frame;
    frame.origin.y = Y;
    self.frame = frame;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

@end
