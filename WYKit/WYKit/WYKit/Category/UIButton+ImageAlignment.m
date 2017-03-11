//
//  UIButton+ImageAlignment.m
//  WYKit
//
//  Created by 汪年成 on 16/12/22.
//  Copyright © 2016年 之静之初. All rights reserved.
//

#import "UIButton+ImageAlignment.h"

@implementation UIButton (ImageAlignment)
// 设置Button文字和图片的方向和距离
- (void)setWithtype:(WYImageAlignment)type titleAndimageRange:(CGFloat)range {
    CGFloat space = range;
    
    CGFloat titleW = CGRectGetWidth(self.titleLabel.bounds);//titleLabel的宽度
    CGFloat titleH = CGRectGetHeight(self.titleLabel.bounds);//titleLabel的高度
    
    CGFloat imageW = CGRectGetWidth(self.imageView.bounds);//imageView的宽度
    CGFloat imageH = CGRectGetHeight(self.imageView.bounds);//imageView的高度
    
    CGFloat btnCenterX = CGRectGetWidth(self.bounds)/2;//按钮中心点X的坐标（以按钮左上角为原点的坐标系）
    CGFloat imageCenterX = btnCenterX - titleW/2;//imageView中心点X的坐标（以按钮左上角为原点的坐标系）
    CGFloat titleCenterX = btnCenterX + imageW/2;//titleLabel中心点X的坐标（以按钮左上角为原点的坐标系）
    
    
    switch (type)
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
+ (instancetype)setButtonWithTitletext:(NSString *)title
                       nomaltitleColor:(UIColor *)nomalColor
                 HighlightedtitleColor:(UIColor *)hiehlightedColor
                            nomalImage:(NSString *)nomalImg
                      HiehlightedImage:(NSString *)hiehlightedImg
                       AndButtonTarget:(id)target
                         buttonSelectd:(SEL)seleted
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:nomalColor forState:UIControlStateNormal];
    [button setTitleColor:hiehlightedColor forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:nomalImg] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hiehlightedImg] forState:UIControlStateHighlighted];
    [button addTarget:target action:seleted forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//  设置带图片的button （不带方法）
+ (instancetype)setButtonWithTitletext:(NSString *)title
                       nomaltitleColor:(UIColor *)nomalColor
                 HighlightedtitleColor:(UIColor *)hiehlightedColor
                            nomalImage:(NSString *)nomalImg
                      HiehlightedImage:(NSString *)hiehlightedImg
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
+ (instancetype)setButtonWithnomalImage:(NSString *)nomalImg
                       HiehlightedImage:(NSString *)hiehlightedImg
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:nomalImg] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hiehlightedImg] forState:UIControlStateHighlighted];
    button.clipsToBounds = YES;
    return button;
}

// 带图片按下状态的button
+ (instancetype)setButtonWithnomalImage:(NSString *)nomalImg
                          SelectedImage:(NSString *)selectedImg
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:nomalImg] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImg] forState:UIControlStateSelected];
    button.clipsToBounds = YES;
    return button;
}

// 带图片文字按下状态的button
+ (instancetype)setButtonWithTitle:(NSString *)title
                        nomalImage:(NSString *)nomalImg
                     SelectedImage:(NSString *)selectedImg
                   AndButtonTarget:(id)target
                     buttonSelectd:(SEL)seleted
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:nomalImg] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImg] forState:UIControlStateSelected];
    [button addTarget:target action:seleted forControlEvents:UIControlEventTouchUpInside];
    button.clipsToBounds = YES;
    return button;
}

// 带图片文字高亮状态的button
+ (instancetype)setButtonWithTitle:(NSString *)title
                        nomalImage:(NSString *)nomalImg
                       HeightImage:(NSString *)heightImg
                   AndButtonTarget:(id)target
                     buttonSelectd:(SEL)seleted
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:nomalImg] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:heightImg] forState:UIControlStateHighlighted];
    [button addTarget:target action:seleted forControlEvents:UIControlEventTouchUpInside];
    button.clipsToBounds = YES;
    return button;
}


//  带背景的button
+ (instancetype)setButtonWithTitletext:(NSString *)title
                       nomaltitleColor:(UIColor *)nomalColor
                 HighlightedtitleColor:(UIColor *)hiehlightedColor
                    nomalBackGroundImg:(NSString *)nomalImg
                  HiehlightedGroundImg:(NSString *)hiehlightedImg
                       AndButtonTarget:(id)target
                         buttonSelectd:(SEL)seleted
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:nomalColor forState:UIControlStateNormal];
    [button setTitleColor:hiehlightedColor forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:nomalImg] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:hiehlightedImg] forState:UIControlStateHighlighted];
    [button addTarget:target action:seleted forControlEvents:UIControlEventTouchUpInside];
    button.clipsToBounds = YES;
    return button;
}

@end
