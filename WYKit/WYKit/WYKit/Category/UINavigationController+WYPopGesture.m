//
//  UINavigationController+WYPopGesture.m
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UINavigationController+WYPopGesture.h"
#import <objc/runtime.h>

@interface UINavigationController (WYPopGesturePrivate)
@property (nonatomic, weak, readonly) id naviDelegate;
@property (nonatomic, weak, readonly) id popDelegate;

@end


@implementation UINavigationController (WYPopGesture)

//  交换方法
+ (void)load
{
    Method originalMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(Pop_viewWillAppear:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}


- (void)Pop_viewWillAppear:(BOOL)animated
{
    [self Pop_viewWillAppear:animated];
    // 只是为了触发PopDelegate的get方法，获取到原始的interactivePopGestureRecognizer的delegate
    [self.popDelegate class];
    // 获取导航栏的代理
    [self.naviDelegate class];
    self.delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.delegate = self.naviDelegate;
    });
}


- (id)popDelegate
{
    id popDelegate = objc_getAssociatedObject(self, _cmd);
    if (!popDelegate) {
        popDelegate = self.interactivePopGestureRecognizer.delegate;
        objc_setAssociatedObject(self, _cmd, popDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return popDelegate;
}

- (id)naviDelegate {
    id naviDelegate = objc_getAssociatedObject(self, _cmd);
    if (!naviDelegate) {
        naviDelegate = self.delegate;
        if (naviDelegate) {
            objc_setAssociatedObject(self, _cmd, naviDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    return naviDelegate;
}



#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    if (self.childViewControllers.count <= 1) {
        return NO;
    }
    // 侧滑手势触发位置
    CGPoint location = [gestureRecognizer locationInView:self.view];
    CGPoint offSet = [gestureRecognizer translationInView:gestureRecognizer.view];
    BOOL ret = (0 < offSet.x && location.x <= 40);
    // NSLog(@"%@ %@",NSStringFromCGPoint(location),NSStringFromCGPoint(offSet));
    return ret;
}

// 只有当系统侧滑手势失败了，才去触发ScrollView的滑动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 让系统的侧滑返回生效
    self.interactivePopGestureRecognizer.enabled = YES;
    if (self.childViewControllers.count > 0) {
        if (viewController == self.childViewControllers[0]) {
            self.interactivePopGestureRecognizer.delegate = self.popDelegate; // 不支持侧滑
        } else {
            self.interactivePopGestureRecognizer.delegate = nil; // 支持侧滑
        }
    }
}

@end



@interface UIViewController (WYPopGesturePrivate)
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *popGestureRecognizer;
@end

@implementation UIViewController (WYPopGesture)

- (void)addPopGestureToView:(UIView *)view
{
    if (!view) return;
    if (!self.navigationController) {
        // 在控制器转场的时候，self.navigationController可能是nil,这里用GCD和递归来处理这种情况
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addPopGestureToView:view];
        });
    } else {
        UIPanGestureRecognizer *pan = self.popGestureRecognizer;
        if (![view.gestureRecognizers containsObject:pan]) {
            [view addGestureRecognizer:pan];
        }
    }
}

- (UIPanGestureRecognizer *)popGestureRecognizer
{
    UIPanGestureRecognizer *pan = objc_getAssociatedObject(self, _cmd);
    if (!pan) {
        // 侧滑返回手势 手势触发的时候，让target执行action
        id target = self.navigationController.popDelegate;
        SEL action = NSSelectorFromString(@"handleNavigationTransition:");
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
        pan.maximumNumberOfTouches = 1;
        pan.delegate = self.navigationController;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        objc_setAssociatedObject(self, _cmd, pan, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return pan;
}

@end


