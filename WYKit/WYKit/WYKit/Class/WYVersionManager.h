//
//  WYVersionManager.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WYVersionPromptType) {
    
    WYVersionPromptNomal = 501,       ///  更新/取消 一直会做检测用户取消不做任何处理
    WYVersionPromptCancel,            ///  更新/不在提醒 用户取消将不会收到任何更新提示
    WYVersionPromptCycle,             ///  更新/稍后提醒我 用户取消将会在指定时间后再次提示用户更新操作
    WYVersionPromptIgnore,            ///  更新/忽略此版本  用户点击忽略此版本将会在下一个版本更新的时候才会收到更新提示
    WYVersionPromptCancelAndCycle,    ///  更新/取消/稍后提醒我
    WYVersionPromptCancelAndIgnore,   ///  更新/取消/忽略此版本
    
};

@interface WYVersionManager : NSObject

/** 初始化方法 */
+ (instancetype)versionDetection;

/** 版本检测提示用户交互类型 default WYVersionPromptNomal */
@property (nonatomic, assign) WYVersionPromptType promptType;

/** 版本检测下一次提示周期(单位/天) default 7 */
@property (nonatomic, assign) NSInteger cycle;

/** 是否显示更新日志内容 default NO */
@property (nonatomic, assign) BOOL isShowUpdateContent;

/** 版本检测 */
- (void)requestVersionUpdateQueryWithAppleId:(NSString *)appleId;


@end
