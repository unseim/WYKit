//
//  WYTouchID.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <LocalAuthentication/LocalAuthentication.h>

/** TouchID 状态 */
typedef NS_ENUM(NSUInteger, TouchIDState) {
    
    TouchIDStateNotSupport = 0,             //  当前设备不支持TouchID
    TouchIDStateSuccess = 1,                //  TouchID 验证成功
    TouchIDStateFail = 2,                   //  TouchID 验证失败
    TouchIDStateUserCancel = 3,             //  TouchID 被用户手动取消
    TouchIDStateInputPassword = 4,          //  用户不使用TouchID,选择手动输入密码
    TouchIDStateSystemCancel = 5,           //  TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)
    TouchIDStatePasswordNotSet = 6,         //  TouchID 无法启动,因为用户没有设置密码
    TouchIDStateTouchIDNotSet = 7,          //  TouchID 无法启动,因为用户没有设置TouchID
    TouchIDStateTouchIDNotAvailable = 8,    //  TouchID 无效
    TouchIDStateTouchIDLockout = 9,         //  TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)
    TouchIDStateAppCancel = 10,             //  当前软件被挂起并取消了授权 (如App进入了后台等)
    TouchIDStateInvalidContext = 11,        //  当前软件被挂起并取消了授权 (LAContext对象无效)
    TouchIDStateVersionNotSupport = 12      //  系统版本不支持TouchID (必须高于iOS 8.0才能使用)
    
};


typedef void (^StateBlock)(TouchIDState state,NSError *error);


@interface WYTouchID : LAContext

/** 初始化单列对象 */
+ (instancetype)sharedInstance;

/** 判断设备是否支持 TouchID */
- (BOOL)canEvaluatePolicy;



/**
 启动TouchID进行验证
 @param desc Touch显示的描述
 @param block 回调状态的block
 */
- (void)showTouchIDWithDescribe:(NSString *)desc
                     BlockState:(StateBlock)block;



@end
