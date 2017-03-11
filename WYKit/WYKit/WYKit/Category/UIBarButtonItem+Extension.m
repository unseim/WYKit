//
//  UIBarButtonItem+Extension.m
//  WYKit
//
//  Created by 汪年成 on 16/12/23.
//  Copyright © 2016年 之静之初. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
//  设置NavigationItem的自定义文字图片按钮
+ (instancetype)itemWithNomalTitle:(NSString *)title
                        TitleColor:(UIColor *)nomal
                        NomalImage:(NSString *)img
                         HighImage:(NSString *)highimg
                            target:(id)target
                            action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highimg] forState:UIControlStateHighlighted];
    [button setTitleColor:nomal forState:UIControlStateNormal];
    [button setTitleColor:nomal forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

// 设置NavigationItem的自定义按钮
+ (instancetype)itemWithImageName:(NSString *)image
                        highImage:(NSString *)highImage
                           target:(id)target
                           action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

// 设置NavigationItem的自定义按下按钮
+ (instancetype)itemWithImageName:(NSString *)image
                      selectImage:(NSString *)selectImg
                           target:(id)target
                           action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectImg] forState:UIControlStateSelected];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

//  设置NavigationItem的自定义返回按钮
+ (instancetype)leftItemWithNomalTitle:(NSString *)title
                            NomalImage:(NSString *)img
                                target:(id)target
                                action:(SEL)action
{
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setTitle:title forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    //    [back setImage:[UIImage imageNamed:@"back-night"] forState:UIControlStateHighlighted];
    [back setTitleColor:kRGB(22, 22, 22) forState:UIControlStateNormal];
    [back setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
//    [back setFrame:CGRectMake(0, 0, 60, 20)];
    [back sizeToFit];
    back.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [back addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:back];
}


//  只有文字的NavigationItem
+ (instancetype)ItemWithNomalTitle:(NSString *)title
                            target:(id)target
                            action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:kRGB(22, 22, 22) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(0, 0, 35, 20)];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)ItemWithNomalTitle:(NSString *)title
                   TitleNomalColor:(UIColor *)nomal
                       HeightColor:(UIColor *)heightcolor
                            target:(id)target
                            action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:nomal forState:UIControlStateNormal];
    [button setTitleColor:heightcolor forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(0, 0, 35, 20)];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}


@end
