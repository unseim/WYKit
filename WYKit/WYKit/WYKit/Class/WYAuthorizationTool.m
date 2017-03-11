//
//  WYAuthorizationTool.m
//  WYKit
//
//  Created by 汪年成 on 17/1/22.
//  Copyright © 2017年 之静之初. All rights reserved.
//

#import "WYAuthorizationTool.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@implementation WYAuthorizationTool

#pragma mark - 相册
+ (void)requestImagePickerAuthorization:(void(^)(WYAuthorizationStatus status))callback {
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
+ (void)requestCameraAuthorization:(void (^)(WYAuthorizationStatus))callback {
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
+ (void)requestAddressBookAuthorization:(void (^)(WYAuthorizationStatus))callback {
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

#pragma mark - callback
+ (void)executeCallback:(void (^)(WYAuthorizationStatus))callback status:(WYAuthorizationStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (callback) {
            callback(status);
        }
    });
}

@end
