//
//  UIViewController+ImagePickerManager.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

typedef void(^photoBlock) (UIImage *photo);

@interface UIViewController (ImagePickerManager)

/**
 *  使用系统ActionSheet来选择打开相机、相册
 *
 *  @param edit  照片是否需要裁剪,默认NO
 *  @param block 照片回调
 */
- (void)showCanEdit:(BOOL)edit photo:(photoBlock)block;

/**
 直接打开图库
 
 @param edit 照片是否需要裁剪,默认NO
 @param block 照片回调
 */
- (void)showPhotoLibraryCanEdit:(BOOL)edit photo:(photoBlock)block;

/**
 直接打开相机
 
 @param edit 照片是否需要裁剪,默认NO
 @param block 照片回调
 */
- (void)showCameraCanEdit:(BOOL)edit photo:(photoBlock)block;


@end
