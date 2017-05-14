//
//  UIViewController+WYKit.m
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//
#import <UIKit/UIKit.h>
#import "UIViewController+WYKit.h"
#import <objc/runtime.h>

static const void *WYBackButtonHandlerKey = &WYBackButtonHandlerKey;
@implementation UIViewController (WYKit)

+ (UIViewController *)findBestViewController:(UIViewController *)vc
{
    if (vc.presentedViewController) {
        // Return presented view controller
        return [UIViewController findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

+ (UIViewController *) currentViewController {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIViewController findBestViewController:viewController];
}



- (void)backButtonTouched:(WYBackButtonHandler)backButtonHandler
{
    objc_setAssociatedObject(self, WYBackButtonHandlerKey, backButtonHandler, OBJC_ASSOCIATION_COPY);
}

- (WYBackButtonHandler)backButtonTouched
{
    return objc_getAssociatedObject(self, WYBackButtonHandlerKey);
}

@end


@implementation UINavigationController (shouldPopItem)
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
   	UIViewController* vc = [self topViewController];
    WYBackButtonHandler handler = [vc backButtonTouched];
    if (handler) {
        
        for (UIView *subview in [navigationBar subviews]) {
            if (subview.alpha < 1) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1;
                }];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(self);
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    }
    
    return NO;
}

@end

