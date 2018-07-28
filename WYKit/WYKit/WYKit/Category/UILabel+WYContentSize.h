//
//  UILabel+WYContentSize.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface UILabel (WYContentSize)

/** 根据宽获取 Label 的尺寸 */
- (CGSize)contentSizeForWidth:(CGFloat)width;

/** 获取 Label 的尺寸 */
- (CGSize)contentSize;

/** 是否被截取 */
- (BOOL)isTruncated;

/** 设置行间距 字间距 */
- (void)setText:(NSString*)text
    lineSpacing:(CGFloat)lineSpacing
    textSpacing:(CGFloat)textSpacing;

/** 计算行高 */
+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;


@end
