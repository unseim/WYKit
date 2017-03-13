//
//  WYColatingTextView.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WYColatingTextViewType) {
    WYColatingTextViewAny,                     //  不做任何处理
    WYColatingTextViewOnlyPhoneNumber,         //  只允许输入11位电话号码
    WYColatingTextViewOnlyNumber,              //  只允许输入数字
    WYColatingTextViewOnlyDecimal,             //  只允许输入小数
    WYColatingTextViewOnlyAlphabet,            //  只允许输入英文字母
    WYColatingTextViewOnlyNumberAndAlphabet,   //  只允许输入数字+英文字母
    WYColatingTextViewOnlyIDCard,              //  只允许输入18位身份证
    WYColatingTextViewOnlyCustom,              //  只允许输入自定义的内容
    WYColatingTextViewNOEmojiAndSpace,         //  禁止输入表情和空格换行
    WYColatingTextViewNOSpace                  //  禁止输入空格
};

@interface WYColatingTextView : NSObject <UITextViewDelegate>

/**
 *  格式类型
 */
@property (assign, nonatomic) WYColatingTextViewType textViewType;

/**
 *  限制长度
 */
@property (assign, nonatomic) NSUInteger limitedLength;

/**
 *  允许的字符集
 */
@property (copy, nonatomic) NSString *characterSet;

/**
 *  小数位
 */
@property (assign, nonatomic) NSUInteger decimalPlace;

/**
 *  字数限制  中文2个字节   英文1个字节
 */
@property (nonatomic ,assign) BOOL isWordLimit;

/**
 *  中文cnInt默认16个字
 */
@property (nonatomic ,assign) NSInteger cnInt;

/**
 *  英文enInt默认24个字
 */
@property (nonatomic ,assign) NSInteger enInt;




/**
 *  初始化方法
 */
- (instancetype)initWithTextView:(UITextView *)textview controller:(UIViewController *)viewController;



@end
