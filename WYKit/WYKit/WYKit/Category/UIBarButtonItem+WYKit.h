//
//  UIBarButtonItem+WYKit.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (WYKit)

/**
 *  设置NavigationItem的自定义文字图片按钮
 *
 *  @param title   文字
 *  @param nomal   文字颜色
 *  @param img     默认图
 *  @param highimg 高亮图
 *  @param target  代理
 *  @param action  方法
 */
+ (instancetype)itemWithNomalTitle:(NSString *)title
                        TitleColor:(UIColor *)nomal
                        NomalImage:(NSString *)img
                         HighImage:(NSString *)highimg
                            target:(id)target
                            action:(SEL)action;

/**
 *  设置NavigationItem的自定义按钮
 *
 *  @param image        默认图片
 *  @param highImage    按下后高亮图片
 *  @param target       self 代理
 *  @param action       方法
 */
+ (instancetype)itemWithImageName:(NSString *)image
                        highImage:(NSString *)highImage
                           target:(id)target
                           action:(SEL)action;

/**
 *  设置NavigationItem的自定义按下按钮
 *
 *  @param image        默认图片
 *  @param highImage    按下后高亮图片
 *  @param target       self 代理
 *  @param action       方法
 */
+ (instancetype)itemWithImageName:(NSString *)image
                      selectImage:(NSString *)selectImg
                           target:(id)target
                           action:(SEL)action;

/**
 *  自定义返回按钮
 *
 *  @param title  文字
 *  @param img    图片名
 *  @param target self 代理
 *  @param action 方法名
 */
+ (instancetype)leftItemWithNomalTitle:(NSString *)title
                            NomalImage:(NSString *)img
                                target:(id)target
                                action:(SEL)action;

/**
 *  自定义文字按钮
 *
 *  @param title  文字
 *  @param target self 代理
 *  @param action 方法名
 */
+ (instancetype)ItemWithNomalTitle:(NSString *)title
                            target:(id)target
                            action:(SEL)action;


/**
 *  自定义文字按钮 带文字属性
 *
 *  @param title        文字
 *  @param nomal        默认颜色
 *  @param heightcolor  高亮颜色
 *  @param target       代理
 *  @param action       方法名
 */
+ (instancetype)ItemWithNomalTitle:(NSString *)title
                   TitleNomalColor:(UIColor *)nomal
                       HeightColor:(UIColor *)heightcolor
                            target:(id)target
                            action:(SEL)action;

@end
