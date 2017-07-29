//
//  UINavigationController+WYPopGesture.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface UINavigationController (WYPopGesture) <UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end



@interface UIViewController (WYPopGesture)

/** 给控制器添加侧滑返回功能 */
- (void)addPopGestureToView:(UIView *)view;



@end