//
//  NSString+WYKit.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

@interface NSObject (WYSize)

/** 自适应宽度 */
- (CGRect)getFrameWithFreeWidth:(CGPoint)origin
                       maxHight:(CGFloat)maxHight;

/** 自适应高度 */
- (CGRect)getFrameWithFreeHight:(CGPoint)origin
                       maxWidth:(CGFloat)maxWidth;

/** 自适应宽度--->可调整字间距 */
- (CGRect)getFrameWithFreeWidth:(CGPoint)origin
                       maxHight:(CGFloat)maxHight
                      textSpace:(CGFloat)textSpace;

/** 自适应高度--->可调整字间距和行间距 */
- (CGRect)getFrameWithFreeHight:(CGPoint)origin
                       maxWidth:(CGFloat)maxWidth
                      textSpace:(CGFloat)textSpace
                      lineSpace:(CGFloat)lineSpace;


@end
