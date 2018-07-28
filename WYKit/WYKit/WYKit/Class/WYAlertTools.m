//
//  WYAlertTools.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYAlertTools.h"
#import <objc/runtime.h>

#pragma mark - UIAlertView类别扩充
//类别，扩充属性
@interface UIAlertView (WYAlertTools)
@property (nonatomic, copy) CallWYckBlock clickBlock;

@end

//runtime内联机制，实现set/get方法
@implementation UIAlertView (WYAlertTools)

- (void)setClickBlock:(CallWYckBlock)block
{
    objc_setAssociatedObject(self, @selector(clickBlock), block, OBJC_ASSOCIATION_COPY);
}
- (CallWYckBlock)clickBlock
{
    return objc_getAssociatedObject(self, @selector(clickBlock));
}
@end

#pragma mark - UIActionSheet类别扩充
//类别，扩充属性
@interface UIActionSheet (WYAlertTools)
@property (nonatomic, copy) CallWYckBlock clickBlock;
@end

//runtime内联机制，实现set/get方法
@implementation UIActionSheet (WYAlertTools)
- (void)setClickBlock:(CallWYckBlock)block
{
    objc_setAssociatedObject(self, @selector(clickBlock), block, OBJC_ASSOCIATION_COPY);
}
- (CallWYckBlock)clickBlock
{
    return objc_getAssociatedObject(self, @selector(clickBlock));
}
@end



#pragma mark - 接口
@interface WYAlertTools () <UIAlertViewDelegate, UIActionSheetDelegate>

@end


@implementation WYAlertTools

#pragma mark - alert 简易提示窗 一个按钮或者无按钮
+ (void)showTipAlertViewWith:(UIViewController *)viewController
                       title:(NSString *)title
                     message:(NSString *)message
                 buttonTitle:(NSString *)btnTitle
                 buttonStyle:(WYAlertActionStyle)btnStyle
{
    if (iOS_Version >= 8.0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        //添加按钮
        if (btnTitle) {
            
            UIAlertAction *singleAction = nil;
            switch (btnStyle) {
                case WYAlertActionStyleDefault:
                    singleAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                    }];
                    [alertController addAction:singleAction];
                    break;
                case WYAlertActionStyleCancel:
                    singleAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        
                    }];
                    [alertController addAction:singleAction];
                    break;
                case WYAlertActionStyleDestructive:
                    singleAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                        
                    }];
                    [alertController addAction:singleAction];
                    break;
                    
                default://默认的
                    singleAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                    }];
                    [alertController addAction:singleAction];
                    break;
            }
        }
        
        [viewController presentViewController:alertController animated:YES completion:nil];
        
        //如果没有按钮，自动延迟消失
        if (btnTitle == nil) {
            //此时self指本类
            [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:AlertViewShowTime];
        }
    }
    else
    {
        UIAlertView * alert = nil;
        
        if (btnTitle) {
            
            switch (btnStyle) {
                case WYAlertActionStyleDefault:
                    alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:btnTitle, nil];
                    break;
                case WYAlertActionStyleCancel:
                    alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:btnTitle otherButtonTitles:nil];
                    break;
                    
                default://默认的
                    alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:btnTitle, nil];
                    break;
            }
        }
        else {
            alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        }
        
        [alert show];
        
        //如果没有按钮，自动延迟消失
        if (btnTitle == nil) {
            [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:AlertViewShowTime];
        }
    }
}

#pragma mark - actionSheet 底部简易提示窗 无按钮
+ (void)showBottomTipViewWith:(UIViewController *)viewController
                        title:(NSString *)title
                      message:(NSString *)message
{
    if (iOS_Version >= 8.0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        
        [viewController presentViewController:alertController animated:YES completion:nil];
        
        //如果没有按钮，自动延迟消失
        [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:AlertViewShowTime];
    }
    else
    {
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        [actionSheet showInView:viewController.view];
        
        //如果没有按钮，自动延迟消失
        [self performSelector:@selector(dismissActionSheet:) withObject:actionSheet afterDelay:AlertViewShowTime];
    }
}

#pragma mark - 普通alert初始化 兼容适配
+ (void)showAlertWith:(UIViewController *)viewController
                title:(NSString *)title
              message:(NSString *)message
        callWYckBlock:(CallWYckBlock)block
    cancelButtonTitle:(NSString *)cancelBtnTitle
destructiveButtonTitle:(NSString *)destructiveBtnTitle
    otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (iOS_Version >= 8.0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        //添加按钮
        if (cancelBtnTitle) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                block(0);
            }];
            [alertController addAction:cancelAction];
        }
        if (destructiveBtnTitle) {
            UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveBtnTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                if (cancelBtnTitle) {block(1);}
                else {block(0);}
            }];
            [alertController addAction:destructiveAction];
        }
        if (otherButtonTitles)
        {
            UIAlertAction *otherActions = [UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (!cancelBtnTitle && !destructiveBtnTitle) {block(0);}
                else if ((cancelBtnTitle && !destructiveBtnTitle) || (!cancelBtnTitle && destructiveBtnTitle)) {block(1);}
                else if (cancelBtnTitle && destructiveBtnTitle) {block(2);}
            }];
            [alertController addAction:otherActions];
            
            va_list args;//定义一个指向个数可变的参数列表指针;
            va_start(args, otherButtonTitles);//va_start 得到第一个可变参数地址
            NSString *title = nil;
            
            int count = 2;
            if (!cancelBtnTitle && !destructiveBtnTitle) {count = 0;}
            else if ((cancelBtnTitle && !destructiveBtnTitle) || (!cancelBtnTitle && destructiveBtnTitle)) {count = 1;}
            else if (cancelBtnTitle && destructiveBtnTitle) {count = 2;}
            
            while ((title = va_arg(args, NSString *)))//指向下一个参数地址
            {
                count ++;
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    block(count);
                }];
                [alertController addAction:otherAction];
            }
            va_end(args);//置空指针
        }
        
        [viewController presentViewController:alertController animated:YES completion:nil];
        
        //如果没有按钮，自动延迟消失
        if (cancelBtnTitle == nil && destructiveBtnTitle == nil && otherButtonTitles == nil) {
            //此时self指本类
            [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:AlertViewShowTime];
        }
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelBtnTitle otherButtonTitles:nil];
        alert.clickBlock = block;
        if (otherButtonTitles)
        {
            [alert addButtonWithTitle:otherButtonTitles];
            va_list args;//定义一个指向个数可变的参数列表指针;
            va_start(args, otherButtonTitles);//va_start 得到第一个可变参数地址
            NSString *title = nil;
            while ((title = va_arg(args, NSString *)))//指向下一个参数地址
            {
                [alert addButtonWithTitle:title];
            }
            va_end(args);//置空指针
        }
        
        [alert show];
        
        //如果没有按钮，自动延迟消失
        if (cancelBtnTitle == nil && otherButtonTitles == nil) {
            [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:AlertViewShowTime];
        }
    }
}


#pragma mark - 普通 actionSheet 兼容适配
+ (void)showActionSheetWith:(UIViewController *)viewController
                      title:(NSString *)title
                    message:(NSString *)message
              callWYckBlock:(CallWYckBlock)block
     destructiveButtonTitle:(NSString *)destructiveBtnTitle
          cancelButtonTitle:(NSString *)cancelBtnTitle
          otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (iOS_Version >= 8.0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        
        //添加按钮
        if (destructiveBtnTitle) {
            UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveBtnTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                block(0);
            }];
            [alertController addAction:destructiveAction];
        }
        if (cancelBtnTitle) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                if (destructiveBtnTitle) {block(1);}
                else {block(0);}
            }];
            [alertController addAction:cancelAction];
        }
        if (otherButtonTitles)
        {
            UIAlertAction *otherActions = [UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (!cancelBtnTitle && !destructiveBtnTitle) {block(0);}
                else if ((cancelBtnTitle && !destructiveBtnTitle) || (!cancelBtnTitle && destructiveBtnTitle)) {block(1);}
                else if (cancelBtnTitle && destructiveBtnTitle) {block(2);}
            }];
            [alertController addAction:otherActions];
            
            va_list args;//定义一个指向个数可变的参数列表指针;
            va_start(args, otherButtonTitles);//va_start 得到第一个可变参数地址
            NSString *title = nil;
            
            int count = 2;
            if (!cancelBtnTitle && !destructiveBtnTitle) {count = 0;}
            else if ((cancelBtnTitle && !destructiveBtnTitle) || (!cancelBtnTitle && destructiveBtnTitle)) {count = 1;}
            else if (cancelBtnTitle && destructiveBtnTitle) {count = 2;}
            
            while ((title = va_arg(args, NSString *)))//指向下一个参数地址
            {
                count ++;
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    block(count);
                }];
                [alertController addAction:otherAction];
            }
            va_end(args);//置空指针
        }
        
        [viewController presentViewController:alertController animated:YES completion:nil];
        
        //如果没有按钮，自动延迟消失
        if (cancelBtnTitle == nil && destructiveBtnTitle == nil && otherButtonTitles == nil) {
            //此时self指本类
            [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:AlertViewShowTime];
        }
    }
    else
    {
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:cancelBtnTitle destructiveButtonTitle:destructiveBtnTitle otherButtonTitles:nil];
        actionSheet.clickBlock = block;
        if (otherButtonTitles)
        {
            [actionSheet addButtonWithTitle:otherButtonTitles];
            va_list args;//定义一个指向个数可变的参数列表指针;
            va_start(args, otherButtonTitles);//va_start 得到第一个可变参数地址
            NSString *title = nil;
            while ((title = va_arg(args, NSString *)))//指向下一个参数地址
            {
                [actionSheet addButtonWithTitle:title];
            }
            va_end(args);//置空指针
        }
        
        [actionSheet showInView:viewController.view];
        
        //如果没有按钮，自动延迟消失
        if (cancelBtnTitle == nil && otherButtonTitles == nil) {
            [self performSelector:@selector(dismissActionSheet:) withObject:actionSheet afterDelay:AlertViewShowTime];
        }
    }
}


#pragma mark - 多按钮列表数组排布alert初始化 兼容适配
+ (void)showArrayAlertWith:(UIViewController *)viewController
                     title:(NSString *)title
                   message:(NSString *)message
             callWYckBlock:(CallWYckBlock)block
         cancelButtonTitle:(NSString *)cancelBtnTitle
     otherButtonTitleArray:(NSArray *)otherBtnTitleArray
     otherButtonStyleArray:(NSArray *)otherBtnStyleArray
{
    if (iOS_Version >= 8.0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        //添加按钮
        if (cancelBtnTitle) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                block(0);
            }];
            [alertController addAction:cancelAction];
        }
        if (otherBtnTitleArray && otherBtnTitleArray.count)
        {
            int count = 0;
            if (cancelBtnTitle) {count = 1;}
            else {count = 0;}
            
            for (int i = 0; i < otherBtnTitleArray.count; i ++) {
                
                NSNumber * styleNum = otherBtnStyleArray[i];
                UIAlertActionStyle actionStyle =  styleNum.integerValue;
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherBtnTitleArray[i] style:actionStyle handler:^(UIAlertAction *action) {
                    block(count);
                }];
                [alertController addAction:otherAction];
                
                count ++;
            }
        }
        
        [viewController presentViewController:alertController animated:YES completion:nil];
        
        //如果没有按钮，自动延迟消失
        if (cancelBtnTitle == nil && (otherBtnStyleArray == nil || otherBtnStyleArray.count == 0)) {
            //此时self指本类
            [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:AlertViewShowTime];
        }
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelBtnTitle otherButtonTitles:nil];
        alert.clickBlock = block;
        
        if (otherBtnTitleArray && otherBtnTitleArray.count)
        {
            for (NSString * title in otherBtnTitleArray) {
                [alert addButtonWithTitle:title];
            }
        }
        
        [alert show];
        
        //如果没有按钮，自动延迟消失
        if (cancelBtnTitle == nil && (otherBtnStyleArray == nil || otherBtnStyleArray.count == 0)) {
            [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:AlertViewShowTime];
        }
    }
}

#pragma mark - 多按钮列表数组排布actionSheet初始化 兼容适配
+ (void)showArrayActionSheetWith:(UIViewController *)viewController
                           title:(NSString *)title
                         message:(NSString *)message
                   callWYckBlock:(CallWYckBlock)block
               cancelButtonTitle:(NSString *)cancelBtnTitle
          destructiveButtonTitle:(NSString *)destructiveBtnTitle
           otherButtonTitleArray:(NSArray *)otherBtnTitleArray
           otherButtonStyleArray:(NSArray *)otherBtnStyleArray
{
    if (iOS_Version >= 8.0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        
        //添加按钮
        if (cancelBtnTitle) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                block(0);
            }];
            [alertController addAction:cancelAction];
        }
        if (otherBtnTitleArray && otherBtnTitleArray.count)
        {
            int count = 0;
            if (cancelBtnTitle) {count = 1;}
            else {count = 0;}
            
            for (int i = 0; i < otherBtnTitleArray.count; i ++) {
                
                NSNumber * styleNum = otherBtnStyleArray[i];
                UIAlertActionStyle actionStyle =  styleNum.integerValue;
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherBtnTitleArray[i] style:actionStyle handler:^(UIAlertAction *action) {
                    block(count);
                }];
                [alertController addAction:otherAction];
                
                count ++;
            }
        }
        
        [viewController presentViewController:alertController animated:YES completion:nil];
        
        //如果没有按钮，自动延迟消失
        if (cancelBtnTitle == nil && (otherBtnStyleArray == nil || otherBtnStyleArray.count == 0)) {
            //此时self指本类
            [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:AlertViewShowTime];
        }
    }
    else
    {
        //关联代理有警告，但是不能用对象否则代理无效
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:cancelBtnTitle destructiveButtonTitle:destructiveBtnTitle otherButtonTitles:nil];
        actionSheet.clickBlock = block;
        
        if (otherBtnTitleArray && otherBtnTitleArray.count)
        {
            for (NSString * title in otherBtnTitleArray) {
                [actionSheet addButtonWithTitle:title];
            }
        }
        
        [actionSheet showInView:viewController.view];
        
        //如果没有按钮，自动延迟消失
        if (cancelBtnTitle == nil && (otherBtnStyleArray == nil || otherBtnStyleArray.count == 0)) {
            [self performSelector:@selector(dismissActionSheet:) withObject:actionSheet afterDelay:AlertViewShowTime];
        }
    }
}


#pragma mark - 无按钮弹窗自动消失 类方法 此时self指本类 下面为类方法 否则崩溃
+ (void)dismissAlertView:(UIAlertView*)alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
+ (void)dismissActionSheet:(UIActionSheet *)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
+ (void)dismissAlertController:(UIAlertController *)alert
{
    [alert dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate 类方法才可执行回调
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (alertView.clickBlock) {
        alertView.clickBlock(buttonIndex);
    }
}
+ (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    alertView.clickBlock = nil;
}

#pragma mark - UIActionSheetDelegate
+ (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.clickBlock) {
        actionSheet.clickBlock(buttonIndex);
    }
}
+ (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    actionSheet.clickBlock = nil;
}


#pragma mark - 是否有alert显示
+ (BOOL)isAlertShowNow
{
    if (iOS_Version >= 8.0) { //同步上面的定义，8.0后默认用alertViewController，所以查找vc
        
        UIViewController * activityVC = [self activityViewController];
        if([activityVC isKindOfClass:[UIAlertController class]]){
            return YES;
        }
        else if([activityVC isKindOfClass:[UINavigationController class]]){
            UINavigationController * nav = (UINavigationController*)activityVC;
            if([nav.visibleViewController isKindOfClass:[UIAlertController class]]){
                return YES;
            }
        }
        return NO;
    }
    else
    { //之前检测alertView
        if (iOS_Version >= 7.0) {
            if ([[UIApplication sharedApplication].keyWindow isMemberOfClass:[UIWindow class]])
            {
                return NO;
            }
            return YES;
        }
        else {
            for (UIWindow* window in [UIApplication sharedApplication].windows) {
                NSArray* subviews = window.subviews;
                if ([subviews count] > 0)
                    if ([[subviews objectAtIndex:0] isKindOfClass:[UIAlertView class]] || [[subviews objectAtIndex:0] isKindOfClass:[UIActionSheet class]])
                        return YES;
            }
            return NO;
        }
    }
}


#pragma mark - 查找当前活动窗口
+ (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}


@end
