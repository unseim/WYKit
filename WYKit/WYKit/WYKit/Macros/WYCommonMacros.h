//
//  WYCommonMacros.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#ifndef WYCommonMacros_h
#define WYCommonMacros_h

#ifdef TARGET_IPHONE_SIMULATOR
/** 是否模拟器 */
#define isSimulatorEquipment TARGET_IPHONE_SIMULATOR
#endif

/** 判断当前设备是否是iPhone */
#define isiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/** 判断当前设备是否是iPad */
#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/** 判断是否是4.0寸的设备 */
#define isPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/** 判断是否是4.7寸的设备 */
#define isPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

/** 判断是否是5.5寸的设备 */
#define isPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1472), [[UIScreen mainScreen] currentMode].size) : NO)


/** 当前系统版本大于等于某版本 */
#define IOS_SYSTEM_VERSION_EQUAL_OR_ABOVE(v) (([[[UIDevice currentDevice] systemVersion] floatValue] >= (v))? (YES):(NO))

/** 当前系统版本小于等于某版本 */
#define IOS_SYSTEM_VERSION_EQUAL_OR_BELOW(v) (([[[UIDevice currentDevice] systemVersion] floatValue] <= (v))? (YES):(NO))

/** 当前系统版本 */
#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

/** iOS7 及更高版本 */
#define iOS7 (IOS_SYSTEM_VERSION >= 7.0)

/** iOS8 及更高版本 */
#define iOS8 (IOS_SYSTEM_VERSION >= 8.0)

/** iOS9 及更高版本 */
#define iOS9 (IOS_SYSTEM_VERSION >= 9.0)

/** iOS10 及更高版本 */
#define iOS10 (IOS_SYSTEM_VERSION >= 10.0)

/** iOS11 及更高版本 */
#define iOS11 (IOS_SYSTEM_VERSION >= 11.0)


/// 常用文件路径
#define PathForDocument NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define PathForLibrary  NSSearchPathForDirectoriesInDomains (NSLibraryDirectory, NSUserDomainMask, YES)[0]
#define PathForCaches   NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES)[0]


/** 弱引用 */
#define WYWeakSelf      __weak typeof(self)     weakSelf   =  self;

/** Block 引用 */
#define WYBlockSelf     __block typeof(self)    blockSelf  =  self;

/** 强引用 */
#define WYStrongSelf    __strong typeof(self)   strongSelf  =  self;


/** 当前视图的宽 */
#define KViewWidth               self.frame.size.width

/** 当前视图的高 */
#define KViewHeight              self.frame.size.height

/** 整个屏幕宽 */
#define KScreenWidth             ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

/** 整个屏幕高 */
#define KScreenHeight            ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

/** 是否是iPhoneX */
#define iPhoneX                  (isPhone && KScreenHeight == 812)

/** 导航栏高度 */
#define KNaviHeight              (iPhoneX ? 88 : 64)

/** TabBar高度 */
#define KTabBarHeight            (iPhoneX ? 83 : 49)

/** iPhoneX 底部多余的高度 */
#define KBottomHeight            (iPhoneX ? 34 : 0)

/** iPhoneX 顶部刘海多余的高度 */
#define KTopHeight               (iPhoneX ? 24 : 0)

/** 针对iPhoneX 高度作出的约束规范 */
#define KRealHeight              (long)(KScreenHeight > 736 ? 736 : KScreenHeight)

/** 相对4.0寸屏幕宽的自动布局 */
#define KRealWidth5(value)       (long)((value)/320.0f * [UIScreen mainScreen].bounds.size.width)

/** 相对4.0寸屏幕高的比例进行屏幕适配 */
#define KRealHeight5(value)      (long)((value)/568.0f * KRealHeight)

/** 相对4.7寸屏幕宽的比例进行屏幕适配 */
#define KRealWidth6(value)       (long)((value)/375.0f * [UIScreen mainScreen].bounds.size.width)

/** 相对4.7寸屏幕高的比例进行屏幕适配 */
#define KRealHeight6(value)      (long)((value)/667.0f * KRealHeight)

/** 相对5.5寸屏幕宽的比例进行屏幕适配 */
#define KRealWidth6P(value)      (long)((value)/414.0f * [UIScreen mainScreen].bounds.size.width)

/** 相对5.5寸屏幕高的比例进行屏幕适配 */
#define KRealHeight6P(value)     (long)((value)/736.0f * KRealHeight)


/** 字体适配 */
#define KFontSize(size)          (long)((KScreenWidth / 375.0f) > 1 ? size * 1.075 : size)

/** 十六进制颜色 */
#define KRGB16HEX(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/** RGB颜色无透明度 */
#define kRGB(R,G,B)             [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]

/** RGB颜色带透明度 */
#define kRGB_alpha(R,G,B,A)     [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

/** 随机色 */
#define KRamdomColor            [UIColor colorWithRed:arc4random_uniform(256)/255.0f green:arc4random_uniform(256)/255.0f blue:arc4random_uniform(256)/255.0f alpha:1.0f]


/** 数字 */
#define KNumber                 @"0123456789"

/** 字母 */
#define KLetter                 @"abcdefghigklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

/** UserDefaults */
#define KUserDefaults           [NSUserDefaults standardUserDefaults]

/** NotificationCenter */
#define KNotificationCenter     [NSNotificationCenter defaultCenter]

/** NSFileManager */
#define KFileManager            [NSFileManager defaultManager]

/** UIApplication */
#define KApplication            [UIApplication sharedApplication]

/** UIApplicationDelegate */
#define KApplicationDelegate    [[UIApplication sharedApplication] delegate]



/** 加载 Bundle 里面的图片 */
#define UIImageLoad(name, type)  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:type]]

/** 加载资源文件夹的图片 */
#define UIImageNamed( name )     [UIImage imageNamed: name]



#endif /* WYCommonMacros_h */
