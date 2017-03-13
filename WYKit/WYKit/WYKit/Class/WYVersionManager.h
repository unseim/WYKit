//
//  WYVersionManager.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WYVersionManager : NSObject

/**
 *  版本监测更新
 *  @param appStoreID          应用在AppStore里面的ID (在iTunes Connect中获取)
 *                             Apple ID （测试）1014895889
 *
 *  @param currentController   要显示的controller
 *  @param isShowReleaseNotes  是否显示版本更新日志
 */
+ (void)getVersionWithAppStoreID:(NSString *)appStoreID
            showInCurrentController:(UIViewController *)currentController
                 isShowReleaseNotes:(BOOL)isShowReleaseNotes;

@end
