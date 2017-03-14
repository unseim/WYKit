//
//  WYColatingTextFeild.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WYColatingTextfeildType) {
    WYColatingTextFeildAny,                     //  不做任何处理
    WYColatingTextFeildOnlyPhoneNumber,         //  只允许输入11位电话号码
    WYColatingTextFeildOnlyNumber,              //  只允许输入数字
    WYColatingTextFeildOnlyDecimal,             //  只允许输入小数
    WYColatingTextFeildOnlyAlphabet,            //  只允许输入英文字母
    WYColatingTextFeildOnlyNumberAndAlphabet,   //  只允许输入数字+英文字母
    WYColatingTextFeildOnlyIDCard,              //  只允许输入18位身份证
    WYColatingTextFeildOnlyCustom,              //  只允许输入自定义的内容
    WYColatingTextFeildNOEmojiAndSpace,         //  禁止输入表情和空格
    WYColatingTextFeildNOSpace                  //  禁止输入空格
};


@interface WYColatingTextFeild : NSObject <UITextFieldDelegate>

/** 格式类型 */
@property (assign, nonatomic) WYColatingTextfeildType textFeildType;

/** 限制长度 */
@property (assign, nonatomic) NSUInteger limitedLength;

/** 允许的字符集 */
@property (copy, nonatomic) NSString *characterSet;

/** 小数位 */
@property (assign, nonatomic) NSUInteger decimalPlace;

/** 字数限制  中文2个字节   英文1个字节 */
@property (nonatomic ,assign) BOOL isWordLimit;

/** 中文cnInt默认16个字 */
@property (nonatomic ,assign) NSInteger cnInt;

/** 英文enInt默认24个字 */
@property (nonatomic ,assign) NSInteger enInt;

/** 初始化方法 */
- (instancetype)initWithTextField:(UITextField *)textField controller:(UIViewController *)viewController;

/** 判断是否为手机号 */
- (BOOL)isValidPhone;

@end

