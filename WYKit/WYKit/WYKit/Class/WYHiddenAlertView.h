//
//  WYHiddenAlertView.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface WYHiddenAlertView : UIView

/**
 *  距离屏幕下方80
 *
 *  @param message 文字
 *  @param time    时间
 */
+ (void)showMessage:(NSString *)message time:(NSTimeInterval)time;

/**
 *  距离屏幕上方150
 *
 *  @param message 文字
 *  @param time    时间
 */
+ (void)showMessage2:(NSString *)message time:(NSTimeInterval)time;

/**
 *  屏幕中心
 *
 *  @param message 文字
 *  @param time    时间
 */
+ (void)showMessage3:(NSString *)message time:(NSTimeInterval)time;

/**
 *  自定义提示框
 *
 *  @param message  文字
 *  @param time     时间
 *  @param distance 距离
 */
+ (void)showMessage:(NSString *)message
               time:(NSTimeInterval)time
       WithDistance:(CGFloat)distance;


@end
