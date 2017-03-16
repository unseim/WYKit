//
//  UIImageView+WYFaceAwareFill.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface UIImageView (WYFaceAwareFill)

/** 图片当人脸被检测到时，它会就以脸部中心替代图片的集合中心 */
- (void)faceAwareFill;

@end
