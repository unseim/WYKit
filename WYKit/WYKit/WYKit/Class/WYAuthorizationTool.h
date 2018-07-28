//
//  WYAuthorizationTool.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

/***======================  iOS 10权限配置列表  ==========================
 麦克风权限：Privacy - Microphone Usage Description
 相机权限： Privacy - Camera Usage Description
 相册权限： Privacy - Photo Library Usage Description
 通讯录权限： Privacy - Contacts Usage Description
 蓝牙权限：Privacy - Bluetooth Peripheral Usage Description
 语音转文字权限：Privacy - Speech Recognition Usage Description
 日历权限：Privacy - Calendars Usage Description
 定位权限：Privacy - Location When In Use Usage Description
 一直定位权限: Privacy - Location Always Usage Description
 位置权限：Privacy - Location Usage Description
 媒体库权限：Privacy - Media Library Usage Description
 健康分享权限：Privacy - Health Share Usage Description
 健康更新权限：Privacy - Health Update Usage Description
 运动使用权限：Privacy - Motion Usage Description
 音乐权限：Privacy - Music Usage Description
 提醒使用权限：Privacy - Reminders Usage Description
 Siri使用权限：Privacy - Siri Usage Description
 电视供应商使用权限：Privacy - TV Provider Usage Description
 视频用户账号使用权限：Privacy - Video Subscriber Account Usage Description
 ======================  iOS 10权限配置列表  ==========================***/

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WYAuthorizationStatus) {
    
    WYAuthorizationStatusAuthorized = 0,    // 已授权
    WYAuthorizationStatusDenied,            // 拒绝
    WYAuthorizationStatusRestricted,        // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
    WYAuthorizationStatusNotSupport         // 硬件等不支持,模拟器
    
};

typedef NS_ENUM(NSUInteger, WYAuthorityNotificationType) {
    
    SystemNotificationAll,                  // 全部推送
    SystemNotificationBadge  = 1,           // 带角标的推送
    SystemNotificationSound   = 2,          // 带声音的推送
    SystemNotificationAlert   = 3           // 带通知的推送
    
};

typedef NS_ENUM(NSUInteger, WYAuthorityNotificationStatus) {
    
    WYNotificationStatusNone,       //  推送未打开
    WYNotificationStatusOpen,       //  推送已打开
    
};

@interface WYAuthorizationTool : NSObject

/** 当用户拒绝以后跳转到 权限设置 */
+ (void)requetSettingForAuth;

/** 请求相册访问权限 */
+ (void)requestImagePickerAuthorization:(void(^)(WYAuthorizationStatus status))callback;

/** 请求相机权限 */
+ (void)requestCameraAuthorization:(void(^)(WYAuthorizationStatus status))callback;

/** 请求通讯录权限 */
+ (void)requestAddressBookAuthorization:(void (^)(WYAuthorizationStatus status))callback;

/** 请求日历权限 */
+ (void)requestCalendarAuthorization:(void (^)(WYAuthorizationStatus status))callback;

/** 请求备忘录权限 */
+ (void)requestMemorandumAuthorization:(void (^)(WYAuthorizationStatus status))callback;

/** 请求麦克风权限 */
+ (void)requestMicrophoneAuthorization:(void (^)(WYAuthorizationStatus status))callback;

/** 请求提醒事项权限 */
+ (void)requestReminderAuthorization:(void (^)(WYAuthorizationStatus status))callback;

/** 请求推送权限 */
+ (void)requestNotificationAuthorization:(WYAuthorityNotificationType)notification;

/** 获取推送打开状态 */
+ (void)AchievetNotificationStatus:(void (^)(WYAuthorityNotificationStatus status))callback;

@end
