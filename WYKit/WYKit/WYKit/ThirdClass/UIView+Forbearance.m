//
//  UIView+Forbearance.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UIView+Forbearance.h"

@implementation UIView (Forbearance)

- (UILayoutPriority)horizontalHuggingPriority {
    return [self contentHuggingPriorityForAxis:UILayoutConstraintAxisHorizontal];
}
- (void)setHorizontalHuggingPriority:(UILayoutPriority)horizontalHuggingPriority {
    [self setContentHuggingPriority:horizontalHuggingPriority forAxis:UILayoutConstraintAxisHorizontal];
}

- (UILayoutPriority)horizontalCompressionResistancePriority {
    return [self contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisHorizontal];
}
- (void)setHorizontalCompressionResistancePriority:(UILayoutPriority)horizontalCompressionResistancePriority {
    [self setContentCompressionResistancePriority:horizontalCompressionResistancePriority forAxis:UILayoutConstraintAxisHorizontal];
}

- (UILayoutPriority)verticalHuggingPriority {
    return [self contentHuggingPriorityForAxis:(UILayoutConstraintAxisVertical)];
}
- (void)setVerticalHuggingPriority:(UILayoutPriority)verticalHuggingPriority {
    [self setContentHuggingPriority:verticalHuggingPriority forAxis:UILayoutConstraintAxisVertical];
}

- (UILayoutPriority)verticalCompressionResistancePriority {
    return [self contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisVertical];
}
- (void)setVerticalCompressionResistancePriority:(UILayoutPriority)verticalCompressionResistancePriority {
    [self setContentCompressionResistancePriority:verticalCompressionResistancePriority forAxis:UILayoutConstraintAxisVertical];
}

@end
