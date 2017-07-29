//
//  UILabel+WYContentSize.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface UILabel (WYContentSize)

- (CGSize)contentSizeForWidth:(CGFloat)width;

- (CGSize)contentSize;

- (BOOL)isTruncated;

/** 设置行间距 字间距 */
- (void)setText:(NSString*)text
    lineSpacing:(CGFloat)lineSpacing
    textSpacing:(CGFloat)textSpacing;

/** 计算行高 */
+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;


@end
