//
//  WYAuthorizationTool.m
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYAuthorizationTool.h"
//  相册
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
//  通讯录
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
//  日历 备忘录
#import <EventKit/EventKit.h>
#import <EventKit/EKEventStore.h>
//  定位
#import <CoreLocation/CLLocationManager.h>
//  麦克风
#import <AVFoundation/AVFoundation.h>
//  健康
#import <HealthKit/HealthKit.h>

#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] < 8.0

@interface WYAuthorizationTool ()

@end

@implementation WYAuthorizationTool

#pragma mark - 跳转权限设置
+ (void)requetSettingForAuth
{
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([app canOpenURL:settingsURL]) {
        [app openURL:settingsURL];
    }
}

#pragma mark - 相册
+ (void)requestImagePickerAuthorization:(void(^)(WYAuthorizationStatus status))callback
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ||
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusNotDetermined) { // 未授权
            if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
                [self executeCallback:callback status:WYAuthorizationStatusAuthorized];
            } else {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) {
                        [self executeCallback:callback status:WYAuthorizationStatusAuthorized];
                    } else if (status == PHAuthorizationStatusDenied) {
                        [self executeCallback:callback status:WYAuthorizationStatusDenied];
                    } else if (status == PHAuthorizationStatusRestricted) {
                        [self executeCallback:callback status:WYAuthorizationStatusRestricted];
                    }
                }];
            }
            
        } else if (authStatus == ALAuthorizationStatusAuthorized) {
            [self executeCallback:callback status:WYAuthorizationStatusAuthorized];
        } else if (authStatus == ALAuthorizationStatusDenied) {
            [self executeCallback:callback status:WYAuthorizationStatusDenied];
        } else if (authStatus == ALAuthorizationStatusRestricted) {
            [self executeCallback:callback status:WYAuthorizationStatusRestricted];
        }
    } else {
        [self executeCallback:callback status:WYAuthorizationStatusNotSupport];
    }
}

#pragma mark - 相机
+ (void)requestCameraAuthorization:(void (^)(WYAuthorizationStatus))callback
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    [self executeCallback:callback status:WYAuthorizationStatusAuthorized];
                } else {
                    [self executeCallback:callback status:WYAuthorizationStatusDenied];
                }
            }];
        } else if (authStatus == AVAuthorizationStatusAuthorized) {
            [self executeCallback:callback status:WYAuthorizationStatusAuthorized];
        } else if (authStatus == AVAuthorizationStatusDenied) {
            [self executeCallback:callback status:WYAuthorizationStatusDenied];
        } else if (authStatus == AVAuthorizationStatusRestricted) {
            [self executeCallback:callback status:WYAuthorizationStatusRestricted];
        }
    } else {
        [self executeCallback:callback status:WYAuthorizationStatusNotSupport];
    }
}

#pragma mark - 通讯录
+ (void)requestAddressBookAuthorization:(void (^)(WYAuthorizationStatus))callback
{
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if (authStatus == kABAuthorizationStatusNotDetermined) {
        __block ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        if (addressBook == NULL) {
            [self executeCallback:callback status:WYAuthorizationStatusNotSupport];
            return;
        }
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                [self executeCallback:callback status:WYAuthorizationStatusAuthorized];
            } else {
                [self executeCallback:callback status:WYAuthorizationStatusDenied];
            }
            if (addressBook) {
                CFRelease(addressBook);
                addressBook = NULL;
            }
        });
        return;
    } else if (authStatus == kABAuthorizationStatusAuthorized) {
        [self executeCallback:callback status:WYAuthorizationStatusAuthorized];
    } else if (authStatus == kABAuthorizationStatusDenied) {
        [self executeCallback:callback status:WYAuthorizationStatusDenied];
    } else if (authStatus == kABAuthorizationStatusRestricted) {
        [self executeCallback:callback status:WYAuthorizationStatusRestricted];
    }
}


#pragma mark - 日历权限
+ (void)requestCalendarAuthorization:(void (^)(WYAuthorizationStatus))callback
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (status) {
        case  EKAuthorizationStatusNotDetermined: {     //  未授权
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:EKEntityTypeEvent
                                       completion:^(BOOL granted, NSError *error)
             {
                 if (error) {
                     [self executeCallback:callback status:WYAuthorizationStatusNotSupport];
                     return;
                 }
                 if (granted) {
                     [self executeCallback:callback status:WYAuthorizationStatusAuthorized];
                 } else {
                     [self executeCallback:callback status:WYAuthorizationStatusDenied];
                 }
             }];
            
        }
            break;
        case EKAuthorizationStatusRestricted:
            [self executeCallback:callback status:WYAuthorizationStatusRestricted];
            break;
        case EKAuthorizationStatusDenied:
            [self executeCallback:callback status:WYAuthorizationStatusDenied];
            break;
        case EKAuthorizationStatusAuthorized:
            [self executeCallback:callback status:WYAuthorizationStatusAuthorized];
            break;
        default:
            break;
    }
}

#pragma mark - 提醒事项
+ (void)requestReminderAuthorization:(void (^)(WYAuthorizationStatus status))callback
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    switch (status) {
        case  EKAuthorizationStatusNotDetermined:  {    //未授权
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:EKEntityTypeReminder
                                       completion:^(BOOL granted, NSError *error)
             {
                 if (error) {
                     [self executeCallback:callback status:WYAuthorizationStatusNotSupport];
                     return;
                 }
                 if (granted) {
                     [self executeCallback:callback status:WYAuthorizationStatusAuthorized];
                 } else {
                     [self executeCallback:callback status:WYAuthorizationStatusDenied];
                 }
             }];
        }
            break;
            
        case EKAuthorizationStatusRestricted:
            [self executeCallback:callback status:WYAuthorizationStatusRestricted];
            break;
            
        case EKAuthorizationStatusDenied:
            [self executeCallback:callback status:WYAuthorizationStatusDenied];
            break;
            
        case EKAuthorizationStatusAuthorized:
            [self executeCallback:callback status:WYAuthorizationStatusAuthorized];
            break;
            
        default:
            break;
    }
}

#pragma mark - 备忘录权限
+ (void)requestMemorandumAuthorization:(void (^)(WYAuthorizationStatus))callback
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    switch (status) {
        case  EKAuthorizationStatusNotDetermined: {     //  未授权
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:EKEntityTypeReminder
                                       completion:^(BOOL granted, NSError *error)
             {
                 if (error) {
                     [self executeCallback:callback status:WYAuthorizationStatusNotSupport];
                     return;
                 }
                 if (granted) {
                     [self executeCallback:callback status:WYAuthorizationStatusAuthorized];
                 } else {
                     [self executeCallback:callback status:WYAuthorizationStatusDenied];
                 }
             }];
            
        }
            break;
        case EKAuthorizationStatusRestricted:
            [self executeCallback:callback status:WYAuthorizationStatusRestricted];
            break;
        case EKAuthorizationStatusDenied:
            [self executeCallback:callback status:WYAuthorizationStatusDenied];
            break;
        case EKAuthorizationStatusAuthorized:
            [self executeCallback:callback status:WYAuthorizationStatusAuthorized];
            break;
        default:
            break;
    }
}


#pragma mark - 麦克风
+ (void)requestMicrophoneAuthorization:(void (^)(WYAuthorizationStatus status))callback
{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (videoAuthStatus) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted)
            {
                if (granted){
                    [self executeCallback:callback status:WYAuthorizationStatusAuthorized];
                }else {
                    [self executeCallback:callback status:WYAuthorizationStatusDenied];
                }
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
            [self executeCallback:callback status:WYAuthorizationStatusRestricted];
            break;
        case AVAuthorizationStatusDenied:
           [self executeCallback:callback status:WYAuthorizationStatusDenied];
            break;
        case AVAuthorizationStatusAuthorized:
            [self executeCallback:callback status:WYAuthorizationStatusAuthorized];
            break;
        default:
            break;
    }
}


#pragma mark - 注册推送
+ (void)requestNotificationAuthorization:(WYAuthorityNotificationType)notification
{
    UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    switch (notificationSettings.types) {
        case UIUserNotificationTypeNone: {
            [self requestNotificationWithType:notification];
        }
            break;
            
        case UIUserNotificationTypeBadge: {
            [self requestNotificationWithType:SystemNotificationBadge];
        }
            break;
            
        case UIUserNotificationTypeSound: {
            [self requestNotificationWithType:SystemNotificationSound];
        }
            break;
            
        case UIUserNotificationTypeAlert: {
            [self requestNotificationWithType:SystemNotificationAlert];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - 推送方式
+ (void)requestNotificationWithType:(WYAuthorityNotificationType)type
{
    switch (type) {
        case SystemNotificationAll: {  //  注册全部推送
            if (IOS7) {
                UIRemoteNotificationType type = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound;
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:type];
            }
            else {
                UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
            }
            
        }
            break;
        case SystemNotificationBadge: {     //  带角标的推送
            if (IOS7) {
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge];
            }
            else {
                UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
                
            }
        }
            break;
        case SystemNotificationSound: {     //  带声音的推送
            if (IOS7) {
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound];
            }
            else {
                UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
                
            }
        }
            break;
        case SystemNotificationAlert: {     //  带通知的推送
            if (IOS7) {
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
            }
            else {
                UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
                
            }
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - 推送打开状态
+ (void)AchievetNotificationStatus:(void (^)(WYAuthorityNotificationStatus))callback
{
    UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    switch (notificationSettings.types) {
        case UIUserNotificationTypeNone: {
            [self notificationCallback:callback status:WYNotificationStatusNone];
        }
            break;
            
        default: {
            [self notificationCallback:callback status:WYNotificationStatusOpen];
        }
            break;
    }
}


#pragma mark - callback
+ (void)executeCallback:(void (^)(WYAuthorizationStatus))callback status:(WYAuthorizationStatus)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (callback) {
            callback(status);
        }
    });
}

#pragma mark - notificationCallback
+ (void)notificationCallback:(void (^)(WYAuthorityNotificationStatus))callback status:(WYAuthorityNotificationStatus)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (callback) {
            callback(status);
        }
    });
}

@end
