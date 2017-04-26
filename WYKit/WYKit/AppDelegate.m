//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//
#import "HomeViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
@interface AppDelegate ()
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
/*
     
     WYKit 是一个包含常用功能分类封装、知名第三方库 AFNetWorking、FMDB二次封装
     
     常用宏定义 为一体的一款框架，在使用过程中，开发者这需要在你的 PCH 文件中导入
     
     #import "WYKit" 即可使用，所有的用法在每一个.h文件中均有说明.
     
     PS：WYKit 是作者做工作中所遇到的一些繁琐代码的封装，所以很多功能并不完善，
     
     部分类还存在一些Bug，需要广大 iOS 开发者提出宝贵意见， 一起完善这个作品 ...
     
*/
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen] .bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
