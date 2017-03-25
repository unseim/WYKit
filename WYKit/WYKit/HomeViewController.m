//
//  HomeViewController.m
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "HomeViewController.h"
@interface HomeViewController ()

@end
@implementation HomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功能测试";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *bu = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [bu setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:bu];
    [bu addTarget:self action:@selector(Mothed) forControlEvents:UIControlEventTouchUpInside];
    
    [self backButtonTouched:^(UIViewController *vc) {
        NSLog(@"不反悔");
    }];
    
    /*
     
     <!-- 相册 -->
     <key>NSPhotoLibraryUsageDescription</key>
     <string>App需要您的同意,才能访问相册</string>
     
     <!-- 相机 -->
     <key>NSCameraUsageDescription</key>
     <string>App需要您的同意,才能访问相机</string>
     
     <!-- 麦克风 -->
     <key>NSMicrophoneUsageDescription</key>
     <string>App需要您的同意,才能访问麦克风</string>
     
     <!-- 位置 -->
     <key>NSLocationUsageDescription</key>
     <string>App需要您的同意,才能访问位置</string>
     
     <!-- 在使用期间访问位置 -->
     <key>NSLocationWhenInUseUsageDescription</key>
     <string>App需要您的同意,才能在使用期间访问位置</string>
     
     <!-- 始终访问位置 -->
     <key>NSLocationAlwaysUsageDescription</key>
     <string>App需要您的同意,才能始终访问位置</string>
     
     <!-- 日历 -->
     <key>NSCalendarsUsageDescription</key>
     <string>App需要您的同意,才能访问日历</string>
     
     <!-- 提醒事项 -->
     <key>NSRemindersUsageDescription</key>
     <string>App需要您的同意,才能访问提醒事项</string>
     
     <!-- 运动与健身 -->
     <key>NSMotionUsageDescription</key> <string>App需要您的同意,才能访问运动与健身</string>
     
     <!-- 健康更新 -->
     <key>NSHealthUpdateUsageDescription</key>
     <string>App需要您的同意,才能访问健康更新 </string>
     
     <!-- 健康分享 -->
     <key>NSHealthShareUsageDescription</key>
     <string>App需要您的同意,才能访问健康分享</string>
     
     <!-- 蓝牙 -->
     <key>NSBluetoothPeripheralUsageDescription</key>
     <string>App需要您的同意,才能访问蓝牙</string>
     
     <!-- 媒体资料库 -->
     <key>NSAppleMusicUsageDescription</key>
     <string>App需要您的同意,才能访问媒体资料库</string>
     
     */
    
    
    /* *********************************************
     
     <key>Privacy - Microphone Usage Description</key>
     <string>访问麦克风权限</string>
     <key>Privacy - Camera Usage Description</key>
     <string>访问相机权限</string>
     <key>Privacy - Photo Library Usage Description</key>
     <string>访问相册权限</string>
     <key>Privacy - Contacts Usage Description</key>
     <string>访问通讯录权限</string>
     <key>Privacy - Bluetooth Peripheral Usage Description</key>
     <string>访问蓝牙权限</string>
     <key>Privacy - Speech Recognition Usage Description</key>
     <string>访问语音转文字权限</string>
     <key>Privacy - Calendars Usage Description</key>
     <string>访问音乐权限</string>
     <key>Privacy - Location When In Use Usage Description</key>
     <string>访问定位权限</string>
     <key>Privacy - Location Always Usage Description</key>
     <string>访问一直定位权限</string>
     <key>Privacy - Location Usage Description</key>
     <string>访问位置权限</string>
     <key>Privacy - Media Library Usage Description</key>
     <string>访问媒体库权限</string>
     <key>Privacy - Health Share Usage Description</key>
     <string>访问健康分享权限</string>
     <key>Privacy - Health Update Usage Description</key>
     <string>访问健康更新权限</string>
     <key>Privacy - Motion Usage Description</key>
     <string>访问运动使用权限</string>
     <key>NSRemindersUsageDescription</key>
     <string>访问提醒权限</string>
     <key>Privacy - Siri Usage Description</key>
     <string>访问Siri权限</string>
     <key>Privacy - TV Provider Usage Description</key>
     <string>访问电视供应商权限</string>
     <key>Privacy - Video Subscriber Account Usage Description</key>
     <string>视频用户账号使用权限</string>
     
     */
}


- (void)Mothed
{
    /*
     
     switch (status) {
     case WYAuthorizationStatusDenied: {
     [WYAuthorizationTool requetSettingForAuth];
     NSLog(@"拒绝");
     }
     break;
     case WYAuthorizationStatusAuthorized:
     NSLog(@"同意");
     break;
     case WYAuthorizationStatusNotSupport:
     NSLog(@"不支持");
     break;
     case WYAuthorizationStatusRestricted:
     NSLog(@"家长控制");
     break;
     default:
     break;
     }
     
     */
    
    
    
    [WYAuthorizationTool requestPositioningAuthorization:^(WYAuthorizationStatus status) {
        
    }];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
