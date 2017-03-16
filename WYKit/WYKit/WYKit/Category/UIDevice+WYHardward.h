//
//  UIDevice+WYHardward.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIDeviceFamily) {
    UIDeviceFamilyiPhone,
    UIDeviceFamilyiPod,
    UIDeviceFamilyiPad,
    UIDeviceFamilyAppleTV,
    UIDeviceFamilyUnknown,
};

@interface UIDevice (WYHardward)

/**
 Returns a machine-readable model name in the format of "iPhone4,1"
 */
- (NSString *)modelIdentifier;

/** 设备机型 */
- (NSString *)modelName;

/** 判断当前设备是否有摄像头 */
+ (BOOL)isValidCamera;

/** 获取手机内存总量, 返回的是字节数 */
+ (NSUInteger)getTotalMemoryBytes;

/** 获取手机可用内存, 返回的是字节数 */
+ (NSUInteger)getFreeMemoryBytes;

/** 获取手机硬盘空闲空间, 返回的是字节数 */
+ (long long)getFreeDiskSpaceBytes;

/** 获取手机硬盘总空间, 返回的是字节数 */
+ (long long)getTotalDiskSpaceBytes;

@end
