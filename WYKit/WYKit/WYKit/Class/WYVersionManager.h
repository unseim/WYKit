//
//  WYVersionManager.h
//  WYKit
//
//  Created by 汪年成 on 17/1/17.
//  Copyright © 2017年 之静之初. All rights reserved.
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
+ (void)updateVersionWithAppStoreID:(NSString *)appStoreID
            showInCurrentController:(UIViewController *)currentController
                 isShowReleaseNotes:(BOOL)isShowReleaseNotes;

@end
