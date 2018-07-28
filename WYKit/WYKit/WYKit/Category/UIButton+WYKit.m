//
//  UIButton+WYKit.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UIButton+WYKit.h"

@implementation UIButton (WYKit)

// 设置Button文字和图片的方向和距离
- (void)setImagePosition:(WYImageAlignment)postion titlesPacingRange:(CGFloat)range
{
    CGFloat space = range;
    
    CGFloat titleW = CGRectGetWidth(self.titleLabel.bounds);//titleLabel的宽度
    CGFloat titleH = CGRectGetHeight(self.titleLabel.bounds);//titleLabel的高度
    
    CGFloat imageW = CGRectGetWidth(self.imageView.bounds);//imageView的宽度
    CGFloat imageH = CGRectGetHeight(self.imageView.bounds);//imageView的高度
    
    CGFloat btnCenterX = CGRectGetWidth(self.bounds)/2;//按钮中心点X的坐标（以按钮左上角为原点的坐标系）
    CGFloat imageCenterX = btnCenterX - titleW/2;//imageView中心点X的坐标（以按钮左上角为原点的坐标系）
    CGFloat titleCenterX = btnCenterX + imageW/2;//titleLabel中心点X的坐标（以按钮左上角为原点的坐标系）
    
    
    switch (postion)
    {
        case WYImageAlignmentTop:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(imageH/2+ space/2, -(titleCenterX-btnCenterX), -(imageH/2 + space/2), titleCenterX-btnCenterX);
            self.imageEdgeInsets = UIEdgeInsetsMake(-(titleH/2 + space/2), btnCenterX-imageCenterX, titleH/2+ space/2, -(btnCenterX-imageCenterX));
        }
            break;
        case WYImageAlignmentLeft:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, space/2, 0,  -space/2);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2, 0, space);
        }
            break;
        case WYImageAlignmentBottom:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(-(imageH/2+ space/2), -(titleCenterX-btnCenterX), imageH/2 + space/2, titleCenterX-btnCenterX);
            self.imageEdgeInsets = UIEdgeInsetsMake(titleH/2 + space/2, btnCenterX-imageCenterX,-(titleH/2+ space/2), -(btnCenterX-imageCenterX));
        }
            break;
        case WYImageAlignmentRight:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageW + space/2), 0, imageW + space/2);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleW+space/2, 0, -(titleW+space/2));
        }
            break;
        default:
            break;
    }
}


//  设置带图片的button （带方法）
+ (instancetype)buttonWithTitletext:title
                    nomalTitleColor:(UIColor *)nomalColor
              highlightedTitleColor:(UIColor *)hiehlightedColor
                         nomalImage:(NSString *)nomalImg
                   hiehlightedImage:(NSString *)hiehlightedImg
                             target:(id)target
                             action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:nomalColor forState:UIControlStateNormal];
    [button setTitleColor:hiehlightedColor forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:nomalImg] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hiehlightedImg] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//  设置带图片的button （不带方法）
+ (instancetype)buttonWithTitletext:(NSString *)title
                    nomalTitleColor:(UIColor *)nomalColor
              highlightedTitleColor:(UIColor *)hiehlightedColor
                         nomalImage:(NSString *)nomalImg
                   hiehlightedImage:(NSString *)hiehlightedImg
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:nomalColor forState:UIControlStateNormal];
    [button setTitleColor:hiehlightedColor forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:nomalImg] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hiehlightedImg] forState:UIControlStateHighlighted];
    button.clipsToBounds = YES;
    return button;
}

// 只有图片的button
+ (instancetype)buttonWithnomalImage:(NSString *)nomalImg
                    hiehlightedImage:(NSString *)hiehlightedImg
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:nomalImg] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hiehlightedImg] forState:UIControlStateHighlighted];
    button.clipsToBounds = YES;
    return button;
}

// 带图片按下状态的button
+ (instancetype)buttonWithnomalImage:(NSString *)nomalImg
                       selectedImage:(NSString *)selectedImg
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:nomalImg] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImg] forState:UIControlStateSelected];
    button.clipsToBounds = YES;
    return button;
}

// 带图片文字按下状态的button
+ (instancetype)buttonWithTitle:(NSString *)title
                     nomalImage:(NSString *)nomalImg
                  selectedImage:(NSString *)selectedImg
                         target:(id)target
                         action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:nomalImg] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImg] forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.clipsToBounds = YES;
    return button;
}

// 带图片文字高亮状态的button
+ (instancetype)buttonWithTitle:(NSString *)title
                     nomalImage:(NSString *)nomalImg
                    HeightImage:(NSString *)heightImg
                         target:(id)target
                         action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:nomalImg] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:heightImg] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.clipsToBounds = YES;
    return button;
}


//  带背景的button
+ (instancetype)buttonWithTitletext:(NSString *)title
                    nomalTitleColor:(UIColor *)nomalColor
              highlightedTitleColor:(UIColor *)hiehlightedColor
                 nomalBackGroundImg:(NSString *)nomalImg
               hiehlightedGroundImg:(NSString *)hiehlightedImg
                             target:(id)target
                             action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:nomalColor forState:UIControlStateNormal];
    [button setTitleColor:hiehlightedColor forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:nomalImg] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:hiehlightedImg] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.clipsToBounds = YES;
    return button;
}

@end
