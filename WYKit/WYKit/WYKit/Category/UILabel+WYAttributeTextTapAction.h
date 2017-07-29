//
//  UILabel+WYAttributeTextTapAction.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@protocol WYAttributeTextDelegate <NSObject>

@optional
/**
 *  WYAttributeTextDelegate
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 *  @param index 点击的字符在数组中的index
 */
- (void)attributeTapReturnString:(NSString *)string
                           range:(NSRange)range
                           index:(NSInteger)index;

@end


@interface WYAttributeModel : NSObject

@property (nonatomic, copy) NSString *str;

@property (nonatomic, assign) NSRange range;

@end


@interface UILabel (WYAttributeTextTapAction)

/** 是否打开点击效果，默认是打开 */
@property (nonatomic, assign) BOOL enabledTapEffect;


/**
 *  给文本添加点击事件Block回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param tapClick 点击事件回调
 */
- (void)addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                              tapClicked:(void (^) (NSString *string , NSRange range , NSInteger index))tapClick;

/**
 *  给文本添加点击事件delegate回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param delegate delegate
 */
- (void)addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                delegate:(id <WYAttributeTextDelegate> )delegate;

@end
