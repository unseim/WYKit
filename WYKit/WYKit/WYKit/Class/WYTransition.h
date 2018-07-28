//
//  WYTransition.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, WYTransitionGestureRecognizerType) {
    
    WYTransitionGestureRecognizerTypePan       = 0, //拖动模式
    WYTransitionGestureRecognizerTypeScreenEdgePan, //边界拖动模式
    
};

@interface WYTransition : NSObject

+ (void)validatePanPackWithWYTransitionGestureRecognizerType:(WYTransitionGestureRecognizerType)type;

@end

@interface UIView (__WYTransition)

/** 使得此view不响应拖返 */
@property (nonatomic, assign) BOOL disableWYTransition;

@end

@interface UINavigationController (DisableWYTransition)

- (void)enabledWYTransition:(BOOL)enabled;

@end

