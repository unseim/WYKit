//
//  WYCodeButton.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

#pragma mark ========================宏定义========================

#define WYColorCoral CFColor(255, 128, 135, 1)
#define WYColorDodgerBlue CFColor(30, 144, 255, 1)
#define WYColorDeepSkyBlue CFColor(0, 191, 255, 1)
#define WYColorTurquoise CFColor(64, 224, 208, 1)
#define WYColorWarmYellow CFColor(255, 239, 148, 1)
#define WYColorMediumPurple CFColor(147, 112, 219, 1)
#define WYColorSeaGreen CFColor(0, 160, 130, 1)

#define CFColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#pragma mark ========================代理协议========================
@class WYCodeButton;

/** 验证码按键代理 */
@protocol WYCodeButtonDelegate <NSObject>
/**
 *  发送验证码的方法
 */
//- (void)securityCodeButtonDidClicked:(WYCodeButton *)securityCodeButton;

/** 发送验证码倒计时完成以后的方法 */
- (void)securityCodeButtonTimingEnded:(WYCodeButton *)securityCodeButton;


/** 按键按下以后 */
- (void)securityCodeButtonUpInSide:(WYCodeButton *)securityCodeButton;


@end


#pragma mark ========================类定义========================
@interface WYCodeButton : UIButton

/** 正常状态下的文字 */
@property (nonatomic, copy) NSString *normalTitle;

/** 禁用状态下的文字 */
@property (nonatomic, copy) NSString *disabledTitle;

/** 计时时间（秒单位） */
@property (nonatomic, assign) int time;

@property (nonatomic, weak) id<WYCodeButtonDelegate> delegate;

/**
 *  通过主题色创建WYCodeButton
 *
 *  @param buttonColor 主题色
 *
 *  @return WYCodeButton对象
 */
- (instancetype)initWithColor:(UIColor *)buttonColor;


/** 发送验证码 */
- (void)securityCode;

@end
