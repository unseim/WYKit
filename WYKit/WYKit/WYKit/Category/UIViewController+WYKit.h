//
//  UIViewController+WYKit.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>


@protocol BackButtonHandlerProtocol <NSObject>
@optional

/** 截取返回事件 */
- (BOOL)navigationShouldPopOnBackButton;

@end




typedef void (^WYBackButtonHandler)(UIViewController *vc);

@interface UIViewController (WYKit) <BackButtonHandlerProtocol>

/** 返回按钮回调 */
- (void)backButtonTouched:(WYBackButtonHandler)backButtonHandler;

/** 获取当前正在显示的ViewController */
+ (UIViewController*)getCurrentViewController;

@end
