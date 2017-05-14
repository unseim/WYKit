//
//  UIButton+WYCountdown.m
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface UIButton (WYDrag)

/** 给button添加拖动功能 */
@property(nonatomic,assign,getter = isDragEnable)   BOOL dragEnable;

/** 给button添加吸附到父类边缘位置功能 */
@property(nonatomic,assign,getter = isAdsorbEnable) BOOL adsorbEnable;

@end
