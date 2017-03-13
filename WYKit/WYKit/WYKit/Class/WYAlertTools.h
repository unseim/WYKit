//
//  WYAlertTools.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  弹框显示的时间，默认1秒
 */
#define AlertViewShowTime 1.0

/**
 *  检测系统版本
 */
#define iOS_Version [[[UIDevice currentDevice] systemVersion] floatValue]

/**
 *  空白标题，如果title直接设置为nil，那么message设置的内容直接被上移为title，message无效，字体就是加粗的样式
 */
#define EmptyTitle iOS_Version >= 7.0 ? @"" : @" "

/**
 *  回调block
 */
typedef void (^CallWYckBlock)(NSInteger btnIndex);

/**
 *  按钮样式，不用系统的是为了版本适配
 */
typedef enum {
    WYAlertActionStyleDefault = 0,
    WYAlertActionStyleCancel,
    WYAlertActionStyleDestructive
}WYAlertActionStyle;




@interface WYAlertTools : NSObject
/**
 *  简易（最多支持单一按钮,按钮无执行响应）alert定义 兼容适配
 *
 *  @param viewController       当前视图，alertController模态弹出的指针
 *  @param title                标题
 *  @param message              信息
 *  @param btnTitle             按钮标题
 *  @param btnStyle             按钮样式
 */
+ (void)showTipAlertViewWith:(UIViewController *)viewController
                       title:(NSString *)title
                     message:(NSString *)message
                 buttonTitle:(NSString *)btnTitle
                 buttonStyle:(WYAlertActionStyle)btnStyle;

/**
 *  actionSheet实现 底部简易提示窗 无按钮
 *
 *  @param viewController 当前视图，alertController模态弹出的指针
 *  @param title          标题
 *  @param message        信息，iOS8之前设置无效
 */
+ (void)showBottomTipViewWith:(UIViewController *)viewController
                        title:(NSString *)title
                      message:(NSString *)message;

/**
 *  普通alert定义 兼容适配alertView和alertController
 *
 *  @param viewController    当前视图，alertController模态弹出的指针
 *  @param title             标题
 *  @param message           详细信息
 *  @param block             用于执行方法的回调block
 *  @param cancelBtnTitle    取消按钮
 *  @param destructiveBtn    alertController的特殊按钮类型
 *  @param otherButtonTitles 其他按钮 变参量 但是按钮类型的相对位置是固定的
 
 *  NS_REQUIRES_NIL_TERMINATION 是一个宏，用于编译时非nil结尾的检查 自动添加结尾的nil
 
 ***注意1***
 //block方法序列号和按钮名称相同，按钮类型排列顺序固定
 //如果取消为nil，则index0为特殊，以此往后类推，以第一个有效按钮为0开始累加
 //取消有的话默认为0
 
 ***注意2***
 destructiveButtonTitle
 iOS8以前，alert设置无效，因为不支持
 iOS8以后，alert设置有效
 */
+ (void)showAlertWith:(UIViewController *)viewController
                title:(NSString *)title
              message:(NSString *)message
        callWYckBlock:(CallWYckBlock)block
    cancelButtonTitle:(NSString *)cancelBtnTitle
destructiveButtonTitle:(NSString *)destructiveBtn
    otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;


/**
 *  普通 actionSheet 兼容适配
 *
 *  @param viewController      当前视图，alertControll模态弹出的指针
 *  @param title               标题
 *  @param message             信息
 *  @param block               用于执行方法的回调block
 *  @param destructiveBtnTitle 特殊按钮
 *  @param cancelBtnTitle      取消按钮标题
 *  @param otherButtonTitles   其他按钮，变参
 
 ***注意***
 message
 iOS8以前，actionSheet设置无效，因为不支持
 iOS8以后，actionSheet设置有效
 */
+ (void)showActionSheetWith:(UIViewController *)viewController
                      title:(NSString *)title
                    message:(NSString *)message
              callWYckBlock:(CallWYckBlock)block
     destructiveButtonTitle:(NSString *)destructiveBtnTitle
          cancelButtonTitle:(NSString *)cancelBtnTitle
          otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;


/**
 *  多按钮列表数组排布alert初始化 兼容适配
 *
 *  @param viewController       当前视图，alertController模态弹出的指针
 *  @param title                标题
 *  @param message              详细信息
 *  @param block                用于执行方法的回调block
 *  @param cancelBtnTitle       取消按钮
 *  @param otherBtnTitleArray   其他按钮数组
 *  @param otherBtnStyleArray   按钮样式数组（普通/特殊），alertView默认为普通样式
 
 ***注意***
 UIAlertActionStyleCancel/JXTAlertActionStyleCancel最多只能有一个，否则崩溃
 Log:
 'UIAlertController can only have one action with a style of UIAlertActionStyleCancel'
 */
+ (void)showArrayAlertWith:(UIViewController *)viewController
                     title:(NSString *)title
                   message:(NSString *)message
             callWYckBlock:(CallWYckBlock)block
         cancelButtonTitle:(NSString *)cancelBtnTitle
     otherButtonTitleArray:(NSArray *)otherBtnTitleArray
     otherButtonStyleArray:(NSArray *)otherBtnStyleArray;


/**
 *  多按钮列表数组排布actionSheet初始化 兼容适配
 *
 *  @param viewController       当前视图，alertController模态弹出的指针
 *  @param title                标题
 *  @param message              详细信息
 *  @param block                用于执行方法的回调block
 *  @param cancelBtnTitle       取消按钮
 *  @param destructiveBtnTitle  特殊（只针对actionSheet）ios8之后设置无效
 *  @param otherBtnTitleArray   其他按钮数组
 *  @param otherBtnStyleArray   按钮样式数组（普通/特殊），alertView默认为普通样式
 
 ***注意1***
 destructiveButtonTitle
 iOS8以前，设置有效，actionSheet，但是此时btnIndex不一样，取消的为1，destructive的为0
 iOS8以后，设置无效，alertController，此时取消的btnIndex为0，该效果请设置样式数组值
 
 ***注意2***
 message
 iOS8以前，actionSheet设置无效，因为不支持
 iOS8以后，actionSheet设置有效
 
 ***注意3***
 UIAlertActionStyleCancel/JXTAlertActionStyleCancel最多只能有一个，否则崩溃
 Log:
 'UIAlertController can only have one action with a style of UIAlertActionStyleCancel'
 */
+ (void)showArrayActionSheetWith:(UIViewController *)viewController
                           title:(NSString *)title
                         message:(NSString *)message
                   callWYckBlock:(CallWYckBlock)block
               cancelButtonTitle:(NSString *)cancelBtnTitle
          destructiveButtonTitle:(NSString *)destructiveBtnTitle
           otherButtonTitleArray:(NSArray *)otherBtnTitleArray
           otherButtonStyleArray:(NSArray *)otherBtnStyleArray;


/**
 *  判断当前是否有alert显示，可以用来去重显示
 *  去重显示时，此方法慎用，因为未做弹窗区分，同时的弹窗有可能是因为重复显示，也可能是不同警告类型的提示窗
 *  用此只能判断出当前页面是否有弹窗显示，不能区分弹窗的类型（是否是同一类型提示）
 *
 *  @return yes -> 有提示窗显示
 */
+ (BOOL)isAlertShowNow;


/**
 *  查找当前活动窗口
 *
 *  @return 窗口vc
 */
+ (UIViewController *)activityViewController;


@end
