//
//  NSArray+WYKit.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WYTransitionGestureRecognizerType)
{
    WYTransitionGestureRecognizerTypePan, //拖动模式
    WYTransitionGestureRecognizerTypeScreenEdgePan, //边界拖动模式
};

@interface WYTransition : NSObject

/** 侧滑拖动返回上一个界面 */
+ (void)validatePanPackWithTransitionGestureRecognizerType:(WYTransitionGestureRecognizerType)type;

@end



@interface UIView (__WYTransition)

/** 此view不响应拖返 */
@property (nonatomic, assign) BOOL disableTransition;

@end

@interface UINavigationController (DisableTransition)

- (void)enabledTransition:(BOOL)enabled;

@end

