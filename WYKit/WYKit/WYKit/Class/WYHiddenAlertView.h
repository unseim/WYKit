//
//  WYHiddenAlertView.h
//  WYKit
//
//  Created by 汪年成 on 17/1/16.
//  Copyright © 2017年 之静之初. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYHiddenAlertView : UIView

/**
 *  距离屏幕下方80
 *
 *  @param message 文字
 *  @param time    时间
 */
+(void)showMessage:(NSString *)message time:(NSTimeInterval)time;

/**
 *  距离屏幕上方150
 *
 *  @param message 文字
 *  @param time    时间
 */
+(void)showMessage2:(NSString *)message time:(NSTimeInterval)time;

/**
 *  屏幕中心
 *
 *  @param message 文字
 *  @param time    时间
 */
+(void)showMessage3:(NSString *)message time:(NSTimeInterval)time;


/**
 *  自定义提示框
 *
 *  @param message  文字
 *  @param time     时间
 *  @param distance 距离
 */
+ (void)showMessage:(NSString *)message time:(NSTimeInterval)time WithDistance:(CGFloat)distance;


@end
