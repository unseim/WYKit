//
//  WYAlertSheet.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface WYAlertSheet : UIView

/** 点击回调 */
@property (nonatomic, copy) void (^clickAlertSheet)(NSInteger clickIndex);

/** 初始化弹窗 */
- (instancetype)initWithtitleArr:(NSArray *)titleArr;

/** 显示弹窗 */
- (void)show;



@end
