//
//  CommonMacros.h
//  WYKit
//
//  Created by 汪年成 on 16/12/23.
//  Copyright © 2016年 之静之初. All rights reserved.
//

#ifndef CommonMacros_h
#define CommonMacros_h


/**
 *  弱引用
 */
#define WYWeakSelf      __weak typeof(self)     weakSelf   =  self;


/**
 *  Block引用
 */
#define WYBlockSelf     __block typeof(self)    blockSelf  =  self;


/**
 *  强引用
 */
#define WYStrongSelf    __strong typeof(self)   strongSelf  =  self;


/**
 *  当前视图的宽
 */
#define KViewWidth               self.view.frame.size.width


/**
 *  当前视图的高
 */
#define KViewHeight              self.view.frame.size.height


/**
 *  整个屏幕宽
 */
#define KScreenWidth             [UIScreen mainScreen].bounds.size.width


/**
 *  整个屏幕高
 */
#define KScreenHeight            [UIScreen mainScreen].bounds.size.height


/**
 *  相对4.0寸屏幕宽的自动布局
 */
#define KRealWidth5(value)       (long)((value)/320.0f * [UIScreen mainScreen].bounds.size.width)


/**
 *  相对4.0寸屏幕高的比例进行屏幕适配
 */
#define KRealHeight5(value)      (long)((value)/568.0f * [UIScreen mainScreen].bounds.size.height)


/**
 *  相对4.7寸屏幕宽的比例进行屏幕适配
 */
#define KRealWidth6(value)       (long)((value)/375.0f * [UIScreen mainScreen].bounds.size.width)


/**
 *  相对4.7寸屏幕高的比例进行屏幕适配
 */
#define KRealHeight6(value)      (long)((value)/667.0f * [UIScreen mainScreen].bounds.size.height)


/**
 *  相对5.5寸屏幕宽的比例进行屏幕适配
 */
#define KRealWidth6P(value)      (long)((value)/414.0f * [UIScreen mainScreen].bounds.size.width)


/**
 *  相对5.5寸屏幕高的比例进行屏幕适配
 */
#define KRealHeight6P(value)     (long)((value)/736.0f * [UIScreen mainScreen].bounds.size.height)


/**
 *  十六进制颜色
 */
#define KRGB16HEX(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


/**
 *  RGB颜色无透明度
 */
#define kRGB(R,G,B)             [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]


/**
 *  RGB颜色带透明度
 */
#define kRGB_alpha(R,G,B,A)     [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

/**
 *  数字
 */
#define KNumber                 @"0123456789"

/**
 *  字母
 */
#define KLetter                 @"abcdefghigklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

/**
 *  UserDefaults
 */
#define KUserDefaults           [NSUserDefaults standardUserDefaults]


#endif /* CommonMacros_h */
