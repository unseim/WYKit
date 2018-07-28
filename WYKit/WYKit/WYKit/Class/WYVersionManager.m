//
//  WYVersionManager.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYVersionManager.h"

typedef void (^CallWYckBlock)(NSInteger btnIndex);
@implementation WYVersionManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cycle = 7;
        self.isShowUpdateContent = NO;
        self.promptType = WYVersionPromptNomal;
    }
    return self;
}

+ (WYVersionManager *)versionDetection {
    return [[WYVersionManager alloc] init];
}

/** 版本检测 */
- (void)requestVersionUpdateQueryWithAppleId:(NSString *)appleId
{
    [self queryappStoreUpdataWithId:appleId
                             succes:^(NSDictionary *appStoreDictionary)
     {
         NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
         NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
         NSString *appStoreVersion = appStoreDictionary[@"version"];//App Store版本号
         NSString *releaseNotes = [appStoreDictionary objectForKey:@"releaseNotes"];//更新日志
         NSString *trackViewUrl = [appStoreDictionary objectForKey:@"trackViewUrl"];
         
         NSLog(@"当前版本号 -> %@  商店版本号 -> %@", currentVersion, appStoreVersion);
         NSInteger versionStatus = [self compareVersionsFormAppStoreVersion:appStoreVersion
                                                             currentVersion:currentVersion];
         NSString *message = [NSString stringWithFormat:@"检测到新版本 %@ 是否更新?", appStoreVersion];;
         if (self.isShowUpdateContent == YES) {
             message = releaseNotes;
         }
         
         if(versionStatus == 1)
         {
             switch (self.promptType) {
                 case WYVersionPromptNomal:
                 {
                     if ([self isAlertShowNow]) return;
                     [self showAlertWithTitle:@"应用版本有更新"
                                      message:message
                                callWYckBlock:^(NSInteger btnIndex)
                      {
                          if (btnIndex == 1) {
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
                          }
                      } cancelButtonTitle:nil
                       destructiveButtonTitle:@"取消"
                            otherButtonTitles:@"更新", nil];
                     
                 } break;
                     
                 case WYVersionPromptCancel:
                 {
                     BOOL isCancel = NO;
                     if ([[self getVersionParams] containsObjectForKey:@"isCancelPrompt"]) {
                         isCancel = [[self getVersionParams][@"isCancelPrompt"] boolValue];
                     }
                     
                     if (isCancel == YES) {
                         return ;
                     }
                     
                     if ([self isAlertShowNow]) return;
                     [self showAlertWithTitle:@"应用版本有更新"
                                      message:message
                                callWYckBlock:^(NSInteger btnIndex)
                      {
                          if (btnIndex == 1) {
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
                          } else {
                              [self writeToVersionObject:@YES forKey:@"isCancelPrompt"];
                          }
                      } cancelButtonTitle:nil
                       destructiveButtonTitle:@"不在提醒"
                            otherButtonTitles:@"更新", nil];
                     
                 } break;
                     
                 case WYVersionPromptCycle:
                 {
                     long long aTimeInterval = [[NSDate date] timeIntervalSince1970];
                     if ([[self getVersionParams] containsObjectForKey:@"lastTimeInterval"])
                     {
                         long long lastInterval = [[self getVersionParams][@"lastTimeInterval"] longLongValue];
                         if (aTimeInterval < lastInterval) {
                             return;
                         }
                     }
                     
                     if ([self isAlertShowNow]) return;
                     [self showAlertWithTitle:@"应用版本有更新"
                                      message:message
                                callWYckBlock:^(NSInteger btnIndex)
                      {
                          if (btnIndex == 1) {
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
                          } else {
                              long long lastTimeInterval = aTimeInterval + 86400 * self.cycle;
                              [self writeToVersionObject:[NSNumber numberWithLongLong:lastTimeInterval] forKey:@"lastTimeInterval"];
                          }
                      } cancelButtonTitle:nil
                       destructiveButtonTitle:@"稍后提醒我"
                            otherButtonTitles:@"更新", nil];
                     
                 } break;
                     
                 case WYVersionPromptIgnore:
                 {
                     NSString *lastVersion = @"";
                     if ([[self getVersionParams] containsObjectForKey:@"lastVersion"]) {
                         lastVersion = [self getVersionParams][@"lastVersion"];
                     }
                     
                     NSInteger update = [self compareVersionsFormAppStoreVersion:appStoreVersion
                                                                  currentVersion:currentVersion];
                     if (update != 1 && lastVersion.length) {
                         return ;
                     }
                     
                     if ([self isAlertShowNow]) return;
                     [self showAlertWithTitle:@"应用版本有更新"
                                      message:message
                                callWYckBlock:^(NSInteger btnIndex)
                      {
                          if (btnIndex == 1) {
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
                          } else {
                              [self writeToVersionObject:appStoreVersion forKey:@"lastVersion"];
                          }
                      } cancelButtonTitle:nil
                       destructiveButtonTitle:@"忽略此版本"
                            otherButtonTitles:@"更新", nil];
                     
                 } break;
                     
                 case WYVersionPromptCancelAndCycle:
                 {
                     long long aTimeInterval = [[NSDate date] timeIntervalSince1970];
                     if ([[self getVersionParams] containsObjectForKey:@"lastTimeInterval"])
                     {
                         long long lastInterval = [[self getVersionParams][@"lastTimeInterval"] longLongValue];
                         if (aTimeInterval < lastInterval) {
                             return;
                         }
                     }
                     
                     if ([self isAlertShowNow]) return;
                     [self showAlertWithTitle:@"应用版本有更新"
                                      message:message
                                callWYckBlock:^(NSInteger btnIndex)
                      {
                          if (btnIndex == 0) {
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
                          } else if (btnIndex == 1)
                          {
                              long long lastTimeInterval = aTimeInterval + 86400 * self.cycle;
                              [self writeToVersionObject:[NSNumber numberWithLongLong:lastTimeInterval] forKey:@"lastTimeInterval"];
                          }
                      } cancelButtonTitle:nil
                       destructiveButtonTitle:nil
                            otherButtonTitles:@"更新", @"稍后提醒我", @"取消", nil];
                 }
                     break;
                     
                 case WYVersionPromptCancelAndIgnore:
                 {
                     NSString *lastVersion = @"";
                     if ([[self getVersionParams] containsObjectForKey:@"lastVersion"]) {
                         lastVersion = [self getVersionParams][@"lastVersion"];
                     }
                     
                     NSInteger update = [self compareVersionsFormAppStoreVersion:appStoreVersion
                                                                  currentVersion:currentVersion];
                     if (update != 1 && lastVersion.length) {
                         return ;
                     }
                     
                     if ([self isAlertShowNow]) return;
                     [self showAlertWithTitle:@"应用版本有更新"
                                      message:message
                                callWYckBlock:^(NSInteger btnIndex)
                      {
                          if (btnIndex == 0) {
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
                          } else if (btnIndex == 1)
                          {
                              [self writeToVersionObject:appStoreVersion forKey:@"lastVersion"];
                          }
                      } cancelButtonTitle:nil
                       destructiveButtonTitle:nil
                            otherButtonTitles:@"更新", @"忽略此版本", @"取消", nil];
                     
                 } break;
                 default:
                     break;
             }
         } else
         {
             NSLog(@"您当前版本已经最新版本");
         }
     }];
}

/** 链接appstore获取商店版本信息 */
- (void)queryappStoreUpdataWithId:(NSString *)appId
                           succes:(void(^)(NSDictionary *appStoreDictionary))succes
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@", appId]];
    
    NSURLRequest *URLRequest = [NSURLRequest requestWithURL:URL];
    NSURLSession *URLSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                             delegate:nil
                                                        delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *URLSessionDataTask = [URLSession dataTaskWithRequest:URLRequest
                                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                                {
                                                    if (data == nil) {
                                                        NSLog(@"您没有连接网络");
                                                        return;
                                                    }
                                                    
                                                    NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                                    if (error) {
                                                        return;
                                                    }
                                                    
                                                    NSArray *resultsArray = JSONDictionary[@"results"];
                                                    if (resultsArray.count < 1)
                                                    {
                                                        NSLog(@"此APPID为未上架的APP或者查询不到");
                                                        return;
                                                    }
                                                    
                                                    NSDictionary *appStoreDictionary = (NSDictionary *)[resultsArray firstObject];
                                                    !succes ?: succes(appStoreDictionary);
                                                }];
    [URLSessionDataTask resume];
}



/** 获取本地存储的版本更新记录数据 */
- (NSDictionary *)getVersionParams
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [NSString stringWithFormat:@"appVersion.plist"];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:plistPath];
    NSDictionary *versionParams = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    return versionParams;
}

/** 添加本地存储的版本更新记录数据 */
- (void)writeToVersionObject:(id)object forKey:(NSString *)key
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [NSString stringWithFormat:@"appVersion.plist"];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:plistPath];
    NSDictionary *versionParams = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:versionParams];
    [params setObject:object forKey:key];
    [params writeToFile:filePath atomically:YES];
}

/** 清空本地存储的版本更新记录数据 */
- (void)clearVersionParams
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [NSString stringWithFormat:@"appVersion.plist"];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:plistPath];
    NSDictionary *versionParams = [[NSDictionary alloc] init];
    [versionParams writeToFile:filePath atomically:YES];
}


#pragma mark - private

/** 系统弹窗 */
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
             callWYckBlock:(CallWYckBlock)block
         cancelButtonTitle:(NSString *)cancelBtnTitle
    destructiveButtonTitle:(NSString *)destructiveBtnTitle
         otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelBtnTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            block(0);
        }];
        [alertController addAction:cancelAction];
    }
    if (destructiveBtnTitle) {
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveBtnTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBtnTitle) {block(1);}
            else {block(0);}
        }];
        [alertController addAction:destructiveAction];
    }
    if (otherButtonTitles)
    {
        UIAlertAction *otherActions = [UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (!cancelBtnTitle && !destructiveBtnTitle) {block(0);}
            else if ((cancelBtnTitle && !destructiveBtnTitle) || (!cancelBtnTitle && destructiveBtnTitle)) {block(1);}
            else if (cancelBtnTitle && destructiveBtnTitle) {block(2);}
        }];
        [alertController addAction:otherActions];
        
        va_list args;//定义一个指向个数可变的参数列表指针;
        va_start(args, otherButtonTitles);//va_start 得到第一个可变参数地址
        NSString *title = nil;
        
        int count = 2;
        if (!cancelBtnTitle && !destructiveBtnTitle) {count = 0;}
        else if ((cancelBtnTitle && !destructiveBtnTitle) || (!cancelBtnTitle && destructiveBtnTitle)) {count = 1;}
        else if (cancelBtnTitle && destructiveBtnTitle) {count = 2;}
        
        while ((title = va_arg(args, NSString *)))//指向下一个参数地址
        {
            count ++;
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                block(count);
            }];
            [alertController addAction:otherAction];
        }
        va_end(args);//置空指针
    }
    
    [[self findCurrentViewController] presentViewController:alertController animated:YES completion:nil];
}


/** 获取当前正在显示的 viewController  */
- (UIViewController *)findCurrentViewController
{
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
}

/** 当前窗口是否还存在其他 AlertControl  */
- (BOOL)isAlertShowNow
{
    UIViewController * activityVC = [self activityViewController];
    if([activityVC isKindOfClass:[UIAlertController class]]){
        return YES;
    }
    else if([activityVC isKindOfClass:[UINavigationController class]]){
        UINavigationController * nav = (UINavigationController*)activityVC;
        if([nav.visibleViewController isKindOfClass:[UIAlertController class]]){
            return YES;
        }
    }
    return NO;
}

/** 比较版本 0.版本相同 1.有新版本可以更新 -1.版本已经是最新版  */
- (NSComparisonResult)compareVersionsFormAppStoreVersion:(NSString *)appStoreVersion
                                          currentVersion:(NSString *)currentVersion
{
    NSMutableArray<NSString *> *destinArr = [[appStoreVersion  componentsSeparatedByString:@"."] mutableCopy];
    NSMutableArray<NSString *> *sourceArr = [[currentVersion componentsSeparatedByString:@"."] mutableCopy];
    
    int max = (int)MAX(destinArr.count, sourceArr.count);
    for (int i = (int)MIN(destinArr.count, sourceArr.count); i < max; i++) {
        !(sourceArr.count == i) ?: [sourceArr addObject:@"0"];
        !(destinArr.count == i) ?: [destinArr addObject:@"0"];
    }
    
    for (int i = 0; i < sourceArr.count; i++) {
        NSInteger n1 = [sourceArr[i] integerValue];
        NSInteger n2 = [destinArr[i] integerValue];
        if (n1 != n2) {
            return n1 > n2 ? NSOrderedAscending : NSOrderedDescending;
        }
    }
    
    return NSOrderedSame;
}

- (UIViewController *)findBestViewController:(UIViewController *)vc
{
    if (vc.presentedViewController) {
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        return vc;
    }
}

- (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}

@end
