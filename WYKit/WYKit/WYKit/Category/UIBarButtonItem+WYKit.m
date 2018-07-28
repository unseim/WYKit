//
//  UIBarButtonItem+WYKit.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UIBarButtonItem+WYKit.h"
#import "WYCommonMacros.h"

@implementation UIBarButtonItem (WYKit)

//  设置NavigationItem的自定义文字图片按钮
+ (instancetype)itemWithNomalTitle:(NSString *)title
                        titleColor:(UIColor *)titleColor
                        nomalImage:(NSString *)nomalImage
                         highImage:(NSString *)highImage
                            target:(id)target
                            action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:nomalImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
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
                            nomalImage:(NSString *)image
                            titleColor:(UIColor *)titleColor
                                target:(id)target
                                action:(SEL)action
{
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setTitle:title forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
    [back setTitleColor:titleColor forState:UIControlStateNormal];
    [back setTitleColor:titleColor forState:UIControlStateHighlighted];
    [back setFrame:CGRectMake(0, 0, 60, 20)];
    [back sizeToFit];
    back.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [back addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:back];
}


//  只有文字的NavigationItem
+ (instancetype)itemWithNomalTitle:(NSString *)title
                            target:(id)target
                            action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:kRGB(22, 22, 22) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(0, 0, 35, 20)];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button sizeToFit];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)itemWithNomalTitle:(NSString *)title
                   nomalColor:(UIColor *)nomal
                       heightColor:(UIColor *)heightcolor
                            target:(id)target
                            action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:nomal forState:UIControlStateNormal];
    [button setTitleColor:heightcolor forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(0, 0, 35, 20)];
    [button sizeToFit];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return [[self alloc] initWithCustomView:button];
}

@end
