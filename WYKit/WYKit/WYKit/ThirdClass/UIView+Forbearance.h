//
//  UIView+Forbearance.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface UIView (Forbearance)

@property (nonatomic, assign) UILayoutPriority horizontalHuggingPriority;
@property (nonatomic, assign) UILayoutPriority horizontalCompressionResistancePriority;
@property (nonatomic, assign) UILayoutPriority verticalHuggingPriority;
@property (nonatomic, assign) UILayoutPriority verticalCompressionResistancePriority;

@end
