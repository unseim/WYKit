//
//  WYAuthorizationTool.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WYAuthorizationStatus) {
    WYAuthorizationStatusAuthorized = 0,    // 已授权
    WYAuthorizationStatusDenied,            // 拒绝
    WYAuthorizationStatusRestricted,        // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
    WYAuthorizationStatusNotSupport         // 硬件等不支持
};

@interface WYAuthorizationTool : NSObject

/**
 *  请求相册访问权限
 *
 */
+ (void)requestImagePickerAuthorization:(void(^)(WYAuthorizationStatus status))callback;

/**
 *  请求相机权限
 *
 */
+ (void)requestCameraAuthorization:(void(^)(WYAuthorizationStatus status))callback;

/**
 *  请求通讯录权限
 *
 */
+ (void)requestAddressBookAuthorization:(void (^)(WYAuthorizationStatus status))callback;


@end
