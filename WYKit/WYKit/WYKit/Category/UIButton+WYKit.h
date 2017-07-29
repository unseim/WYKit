//
//  UIButton+WYKit.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WYImageAlignment)
{
    WYImageAlignmentLeft = 0,   //  图片在左，默认
    WYImageAlignmentTop,        //  图片在上
    WYImageAlignmentBottom,     //  图片在下
    WYImageAlignmentRight,      //  图片在右
};

@interface UIButton (WYKit)


/**
 *  设置Button文字和图片的方向和距离
 *
 *  @param type     图片所在的方向(上、下、左、右)
 *  @param range    图片和文字的距离
 */
- (void)setImagePosition:(WYImageAlignment)postion titlesPacingRange:(CGFloat)range;


/**
 *  设置带图片的 Button (带方法)
 *
 *  @param title                文字
 *  @param nomalColor           默认文字颜色
 *  @param hiehlightedColor     高亮文字颜色
 *  @param nomalImg             默认图片
 *  @param hiehlightedImg       高亮图片
 *  @param seleted              点击后做的事情
 */
+ (instancetype)setButtonWithTitletext:(NSString *)title
                       nomaltitleColor:(UIColor *)nomalColor
                 HighlightedtitleColor:(UIColor *)hiehlightedColor
                            nomalImage:(NSString *)nomalImg
                      HiehlightedImage:(NSString *)hiehlightedImg
                       AndButtonTarget:(id)target
                         buttonSelectd:(SEL)seleted;


/**
 *  设置带图片的 Button （不带方法）
 *
 *  @param title                文字
 *  @param nomalColor           默认文字颜色
 *  @param hiehlightedColor     文字高亮颜色
 *  @param nomalImg             默认图片
 *  @param hiehlightedImg       高亮图片
 */
+ (instancetype)setButtonWithTitletext:(NSString *)title
                       nomaltitleColor:(UIColor *)nomalColor
                 HighlightedtitleColor:(UIColor *)hiehlightedColor
                            nomalImage:(NSString *)nomalImg
                      HiehlightedImage:(NSString *)hiehlightedImg;



/**
 *  设置只有图片的Button
 *
 *  @param nomalImg       默认图片
 *  @param hiehlightedImg 高亮图片
 */
+ (instancetype)setButtonWithnomalImage:(NSString *)nomalImg
                       HiehlightedImage:(NSString *)hiehlightedImg;


/**
 *  设置带图片图片按下状态的Button
 *
 *  @param nomalImg       默认图片
 *  @param selectedImg    按下过后的图片
 */
+ (instancetype)setButtonWithnomalImage:(NSString *)nomalImg
                          SelectedImage:(NSString *)selectedImg;


/**
 *  带图片文字按下状态的 Button
 *
 *  @param title       默认文字
 *  @param nomalImg    默认图片
 *  @param selectedImg 按下图片
 *
 */
+ (instancetype)setButtonWithTitle:(NSString *)title
                        nomalImage:(NSString *)nomalImg
                     SelectedImage:(NSString *)selectedImg
                   AndButtonTarget:(id)target
                     buttonSelectd:(SEL)seleted;


/**
 *  带图片文字按下状态的 Button
 *
 *  @param title       默认文字
 *  @param nomalImg    默认图片
 *  @param heightImg   高亮图片
 *
 */
+ (instancetype)setButtonWithTitle:(NSString *)title
                        nomalImage:(NSString *)nomalImg
                       HeightImage:(NSString *)heightImg
                   AndButtonTarget:(id)target
                     buttonSelectd:(SEL)seleted;


/**
 *  设置带背景的 Button (带方法)
 *
 *  @param title                文字
 *  @param nomalColor           默认文字颜色
 *  @param hiehlightedColor     高亮文字颜色
 *  @param nomalImg             默认背景图片
 *  @param hiehlightedImg       高亮背景图片
 *  @param seleted              点击后做的事情
 */
+ (instancetype)setButtonWithTitletext:(NSString *)title
                       nomaltitleColor:(UIColor *)nomalColor
                 HighlightedtitleColor:(UIColor *)hiehlightedColor
                    nomalBackGroundImg:(NSString *)nomalImg
                  HiehlightedGroundImg:(NSString *)hiehlightedImg
                       AndButtonTarget:(id)target
                         buttonSelectd:(SEL)seleted;

@end
