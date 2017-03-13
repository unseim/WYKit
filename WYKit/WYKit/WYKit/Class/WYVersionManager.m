//
//  WYVersionManager.m
//  WYKit
//
//  Created by 汪年成 on 17/1/17.
//  Copyright © 2017年 之静之初. All rights reserved.
//

#import "WYVersionManager.h"

@implementation WYVersionManager

/*
 * 需要加上/cn
 * itunes.apple.com/cn/lookup?id=你的appid
 *  一定要先配置自己项目在iTunes Connect的Apple ID
 */
+ (void)getVersionWithAppStoreID:(NSString *)appStoreID
         showInCurrentController:(UIViewController *)currentController
              isShowReleaseNotes:(BOOL)isShowReleaseNotes
{
    //确定请求路径
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@", appStoreID]];
    
    //创建请求对象 请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *URLRequest = [NSURLRequest requestWithURL:URL];
    
    /*
     第一个参数：会话对象的配置信息defaultSessionConfiguration 表示默认配置
     第二个参数：谁成为代理，此处为控制器本身即self
     第三个参数：队列，该队列决定代理方法在哪个线程中调用，可以传主队列|非主队列
     [NSOperationQueue mainQueue]   主队列：   代理方法在主线程中调用
     [[NSOperationQueue alloc]init] 非主队列： 代理方法在子线程中调用
     */
    NSURLSession *URLSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                   delegate:nil
                                                              delegateQueue:[NSOperationQueue mainQueue]];
    
    //根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask *URLSessionDataTask = [URLSession dataTaskWithRequest:URLRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //获取当前工程项目版本号
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
//        NSLog(@"infoDictionary %@", infoDictionary);
        
        NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        if (data == nil) {
            NSLog(@"您没有连接网络");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您没有连接网络 !" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            return;
        }
        
        NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if (error) {
//            NSLog(@"error %@", error);
            return;
        }
        
//        NSLog(@"%@", JSONDictionary);
        
        
        //KEYresultCount = 1//表示搜到一个符合你要求的APP
        //results =（）//这是个只有一个元素的数组，里面都是app信息，那一个元素就是一个字典。里面有各种key。其中有 trackName （名称）trackViewUrl = （下载地址）version （可显示的版本号）等
        NSArray *resultsArray = JSONDictionary[@"results"];
        
        if (resultsArray.count < 1) {
            NSLog(@"此APPID为未上架的APP或者查询不到");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"此APPID为未上架的APP或者查询不到 !" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            return;
        }
        
        NSDictionary *appStoreDictionary = [resultsArray firstObject];
        
        NSString *appStoreVersion = appStoreDictionary[@"version"];//App Store版本号
        NSString *releaseNotes = [appStoreDictionary objectForKey:@"releaseNotes"];//更新日志
        NSString *trackViewUrl = [appStoreDictionary objectForKey:@"trackViewUrl"];
        
        //打印版本号
        NSLog(@"当前版本号:%@\n商店版本号:%@", currentVersion, appStoreVersion);
        //设置版本号
        currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        if (currentVersion.length==2) {
            currentVersion  = [currentVersion stringByAppendingString:@"0"];
        }else if (currentVersion.length==1){
            currentVersion  = [currentVersion stringByAppendingString:@"00"];
        }
        appStoreVersion = [appStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        if (appStoreVersion.length==2) {
            appStoreVersion  = [appStoreVersion stringByAppendingString:@"0"];
        }else if (appStoreVersion.length==1){
            appStoreVersion  = [appStoreVersion stringByAppendingString:@"00"];
        }
        
        BOOL isNewVersion = [WYVersionManager compareVersionsFormAppStoreVersion:appStoreVersion currentAppVersion:currentVersion];
        
        //App Store有新版本 则更新版本
        if(isNewVersion == YES) {
            
            NSString *message = [NSString string];
            
            if (isShowReleaseNotes == YES) {//显示App Store里面 应用版本更新日志
                message = releaseNotes;
            } else {//显示固定更新提示
                message = [NSString stringWithFormat:@"检测到新版本(%@), 是否更新?", appStoreDictionary[@"version"]];
            }
            
            UIAlertController *updateAlertController = [UIAlertController alertControllerWithTitle:@"应用版本有更新" message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *updateAlertAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //此处加入应用在App Store的地址，方便用户去跳转更新，一种实现方式如下
                //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", appStoreID]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
            }];
            
            UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [updateAlertController addAction:updateAlertAction];
            [updateAlertController addAction:cancelAlertAction];
            [currentController presentViewController:updateAlertController animated:YES completion:nil];
        } else {
            NSLog(@"您当前版本已经最新");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您当前版本已经最新 !" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
        }
    }];
    
    //执行任务
    [URLSessionDataTask resume];
}


//比较版本的方法，在这里用的是Version来比较的
+ (BOOL)compareVersionsFormAppStoreVersion:(NSString*)AppStoreVersion currentAppVersion:(NSString*)currentAppVersion {
    
    BOOL littleSunResult = false;
    
    NSMutableArray* a = (NSMutableArray*) [AppStoreVersion componentsSeparatedByString: @"."];
    NSMutableArray* b = (NSMutableArray*) [currentAppVersion componentsSeparatedByString: @"."];
    
    while (a.count < b.count) { [a addObject: @"0"]; }
    while (b.count < a.count) { [b addObject: @"0"]; }
    
    for (int j = 0; j<a.count; j++) {
        if ([[a objectAtIndex:j] integerValue] > [[b objectAtIndex:j] integerValue]) {
            littleSunResult = true;
            break;
        }else if([[a objectAtIndex:j] integerValue] < [[b objectAtIndex:j] integerValue]){
            littleSunResult = false;
            break;
        }else{
            littleSunResult = false;
        }
    }
    return littleSunResult;//true就是有新版本，false就是没有新版本
}


@end
