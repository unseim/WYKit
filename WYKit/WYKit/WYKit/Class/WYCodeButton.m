//
//  WYCodeButton.m
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYCodeButton.h"

#pragma mark ========================宏定义========================

#define WYCodeButtonFont [UIFont boldSystemFontOfSize:12]
#define WYCodeButtonTitleColorDark CFColor(50, 50, 50, 1)

#pragma mark ========================类扩展========================
@interface WYCodeButton ()

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int tempTime;

@end

#pragma mark ========================类实现========================
@implementation WYCodeButton

/**
 *  通过主题色初始化一个WYCodeButton
 *
 *  @param buttonColor 主题色
 *
 *  @return WYCodeButton对象
 */
- (instancetype)initWithColor:(UIColor *)buttonColor {
    if (self = [super init]) {
        [self setTitleColor:WYCodeButtonTitleColorDark forState:UIControlStateNormal];
        
        [self.titleLabel setFont:WYCodeButtonFont];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:5.0];
        
        UIColor *normalColor = buttonColor;
        UIColor *heighlightColor = [self heightLightColor:normalColor];
        [self setBackgroundImage:[self createImageWithColor:normalColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[self createImageWithColor:heighlightColor] forState:UIControlStateHighlighted];
        
        [self addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
        
        // 设置默认
        _normalTitle = @"发送验证码";
        _disabledTitle = @"重新发送";
        _color = buttonColor;
        _time = 60;
        _tempTime = 60;
        
    }
    return self;
    
}

//- (void)clicked {
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timing) userInfo:nil repeats:YES];
//    self.enabled = NO;
//    self.tempTime = self.time;
//    
//    if ([self.delegate respondsToSelector:@selector(securityCodeButtonDidClicked:)]) {
//        [self.delegate securityCodeButtonDidClicked:self];
//    }
//    
//}



- (void)clicked {
    
    if ([self.delegate respondsToSelector:@selector(securityCodeButtonUpInSide:)]) {
        [self.delegate securityCodeButtonUpInSide:self];
    }
    
}

- (void)securityCode {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timing) userInfo:nil repeats:YES];
    self.enabled = NO;
    self.tempTime = self.time;
}




- (void)timing {
    if (self.tempTime == 0) {
        // 停止计时器
        [self.timer invalidate];
        self.timer = nil;
        self.enabled = YES;
        self.tempTime = self.time;
        if ([self.delegate respondsToSelector:@selector(securityCodeButtonTimingEnded:)]) {
            [self.delegate securityCodeButtonTimingEnded:self];
        }
    }
    [self setTitle:[NSString stringWithFormat:@"%@(%d)",self.disabledTitle, self.tempTime] forState:UIControlStateDisabled];
    self.tempTime --;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置frame
    NSString *disabledTitle = [NSString stringWithFormat:@"%@(%d)", self.disabledTitle, self.time];
    
    CGFloat normalTitleWidth = [self sizeWithText:self.normalTitle maxSize:CGSizeMake(0, 30) font:WYCodeButtonFont].width;
    CGFloat disabledTitleWidth = [self sizeWithText:disabledTitle maxSize:CGSizeMake(0, 30) font:WYCodeButtonFont].width;
    CGFloat width = (normalTitleWidth >= disabledTitleWidth ? normalTitleWidth : disabledTitleWidth) + 10;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, 30);
    
    // 设置标题
    [self setTitle:self.normalTitle forState:UIControlStateNormal];
    [self setTitleColor:[self isDarkColor:self.color]?[UIColor whiteColor]:[UIColor blackColor] forState:UIControlStateNormal];
}



#pragma mark ========================封装方法========================
/**
 *  获取文字宽度
 *
 *  @param text    文字
 *  @param maxSize 最大尺寸范围
 *  @param font    字体
 *
 *  @return 文字宽度
 */
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font {
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/**
 *  通过颜色创建一个图片
 *
 *  @param color 颜色
 *
 *  @return 图片
 */
- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 5, 5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/**
 *  判断是否是深色
 *
 *  @param newColor 颜色
 *
 *  @return 是否是深色BOOL值
 */
-(BOOL)isDarkColor:(UIColor *)color{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    double g = components[0] * 255 * 0.299 + components[1] * 255 * 0.587 + components[2] * 255 * 0.114;
    if (g < 192) {
        return YES;
    }
    else {
        return NO;
    }
}

/**
 *  获取颜色的alpha值
 *
 *  @param color 颜色
 *
 *  @return alpha值
 */
- (CGFloat) alphaForColor:(UIColor*)color {
    CGFloat r, g, b, a, w, h, s, l;
    BOOL compatible = [color getWhite:&w alpha:&a];
    if (compatible) {
        return a;
    } else {
        compatible = [color getRed:&r green:&g blue:&b alpha:&a];
        if (compatible) {
            return a;
        } else {
            [color getHue:&h saturation:&s brightness:&l alpha:&a];
            return a;
        }
    }
}

/**
 *  获取颜色的高亮颜色
 *
 *  @param color 原颜色
 *
 *  @return 高亮颜色
 */
- (UIColor *)heightLightColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    return [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha: 0.6];
}



@end
