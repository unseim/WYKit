//
//  WYCommonMacros.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#ifndef WYCommonMacros_h
#define WYCommonMacros_h

#ifdef TARGET_IPHONE_SIMULATOR
/** 是否模拟器 */
#define isSimulatorEquipment TARGET_IPHONE_SIMULATOR
#endif


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

/** iOS 及更高版本 */
#define iOS7 (IOS_SYSTEM_VERSION >= 7.0)


/// 常用文件路径
#define PathForDocument NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define PathForLibrary  NSSearchPathForDirectoriesInDomains (NSLibraryDirectory, NSUserDomainMask, YES)[0]
#define PathForCaches   NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES)[0]


/** 弱引用 */
#define WYWeakSelf      __weak typeof(self)     weakSelf   =  self;

/** Block引用 */
#define WYBlockSelf     __block typeof(self)    blockSelf  =  self;

/** 强引用 */
#define WYStrongSelf    __strong typeof(self)   strongSelf  =  self;


/** 当前视图的宽 */
#define KViewWidth               self.frame.size.width

/** 当前视图的高 */
#define KViewHeight              self.frame.size.height

/** 整个屏幕宽 */
#define KScreenWidth             [UIScreen mainScreen].bounds.size.width

/** 整个屏幕高 */
#define KScreenHeight            [UIScreen mainScreen].bounds.size.height

/** 相对4.0寸屏幕宽的自动布局 */
#define KRealWidth5(value)       (long)((value)/320.0f * [UIScreen mainScreen].bounds.size.width)

/** 相对4.0寸屏幕高的比例进行屏幕适配 */
#define KRealHeight5(value)      (long)((value)/568.0f * [UIScreen mainScreen].bounds.size.height)

/** 相对4.7寸屏幕宽的比例进行屏幕适配 */
#define KRealWidth6(value)       (long)((value)/375.0f * [UIScreen mainScreen].bounds.size.width)

/** 相对4.7寸屏幕高的比例进行屏幕适配 */
#define KRealHeight6(value)      (long)((value)/667.0f * [UIScreen mainScreen].bounds.size.height)

/** 相对5.5寸屏幕宽的比例进行屏幕适配 */
#define KRealWidth6P(value)      (long)((value)/414.0f * [UIScreen mainScreen].bounds.size.width)

/** 相对5.5寸屏幕高的比例进行屏幕适配 */
#define KRealHeight6P(value)     (long)((value)/736.0f * [UIScreen mainScreen].bounds.size.height)


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
#define KApplicationDelegate    [[UIApplication sharedApplication] delegate]


/** 加载 Bundle 里面的图片 */
#define UIImageLoad(name, type)  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:type]]

/** 加载资源文件夹的图片 */
#define UIImageNamed( name )     [UIImage imageNamed: name]



#endif /* WYCommonMacros_h */
