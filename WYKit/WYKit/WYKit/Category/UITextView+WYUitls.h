//
//  UITextView+WYUitls.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface UITextView (WYUitls)

/** 设置行距及字体大小 */
- (void)setText:(NSString*)text
       fontSize:(CGFloat)size
    lineSpacing:(CGFloat)lineSpacing;

@end
