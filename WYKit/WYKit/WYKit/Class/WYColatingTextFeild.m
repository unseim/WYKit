//
//  WYColatingTextFeild.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYColatingTextFeild.h"

@interface WYColatingTextFeild () <UITextFieldDelegate>
@property (nonatomic, assign) WYColatingTextfeildType textFeildType;    /** 格式类型 */
@end

@implementation WYColatingTextFeild

+ (instancetype)textFeildWithTextFeildType:(WYColatingTextfeildType)textFeildType {
    return [[WYColatingTextFeild alloc] initWithTextFeildType:textFeildType];
}

- (instancetype)initWithTextFeildType:(WYColatingTextfeildType)textFeildType {
    self = [super init];
    if (self) {
        self.delegate = self;
        _textFeildType = textFeildType;
        _limitedLength = INT16_MAX;
        _characterSet = @"";
        _cnInt = INT16_MAX;
        _enInt = INT16_MAX;
        _decimalPlace = 1;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _textFeildType = WYColatingTextFeildAny;
    }
    return self;
}

- (void)setIsWordLimit:(BOOL)isWordLimit
{
    if (isWordLimit == YES) {
        ///字数改变
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(textFiledEditChanged:)
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:nil];
    }
}

- (void)textFiledEditChanged:(NSNotification *)obj {
    
    NSInteger length_cn = 0;
    NSInteger length_en = 0;
    
    length_cn = _cnInt;
    length_en = _enInt;
    
    NSString *toBeString = self.text;
    
    //中英占位比例
    CGFloat scale = (CGFloat)length_en/(CGFloat)length_cn;
    UITextRange *selectedRange = [self markedTextRange];
    //获取高亮部分
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        //计算汉字和非汉字的数量，key：enNum和zhNum
        int enNum = 0;
        int cnNum = 0;
        for(int i=0; i< [toBeString length];i++){
            int a = [toBeString characterAtIndex:i];
            if( a > 0x4e00 && a < 0x9fff){
                cnNum++;
            } else {
                enNum++;
            }
            CGFloat length = cnNum * scale + enNum;
            if (length > length_en) {
                if (enNum == 0) {
                    ///纯汉字
                    self.text = [toBeString substringToIndex:length_cn];
                }else if (cnNum == 0 ) {
                    ///纯英文
                    self.text = [toBeString substringToIndex:length_en];
                }else {
                    ///中英文
                    self.text = [toBeString substringToIndex:cnNum + enNum - 1];
                }
                return;
            }
        }
    }
    // 有高亮选择的字符串，则暂不对文字进行统计和限制
    else{
        
    }
}

- (void)setCnInt:(NSInteger)cnInt
{
    _cnInt = cnInt;
}

- (void)setEnInt:(NSInteger)enInt
{
    _enInt = enInt;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *regexString;
    switch (_textFeildType) {
        case WYColatingTextFeildAny:
        {
            return YES;
        }
        case WYColatingTextFeildOnlyPhoneNumber:
        {
            regexString = @"^\\d{0,11}$";
            break;
        }
        case WYColatingTextFeildOnlyNumber:
        {
            regexString = @"^\\d*$";
            break;
        }
        case WYColatingTextFeildOnlyDecimal:
        {
            regexString = [NSString stringWithFormat:@"^(\\d+)\\.?(\\d{0,%lu})$", _decimalPlace];
            break;
        }
        case WYColatingTextFeildOnlyAlphabet:
        {
            regexString = @"^[a-zA-Z]*$";
            break;
        }
        case WYColatingTextFeildOnlyNumberAndAlphabet:
        {
            regexString = @"^[a-zA-Z0-9]*$";
            break;
        }
        case WYColatingTextFeildOnlyIDCard:
        {
            regexString = @"^\\d{1,17}[0-9Xx]?$";
            break;
        }
        case WYColatingTextFeildOnlyCustom:
        {
            regexString = [NSString stringWithFormat:@"^[%@]{0,%lu}$", _characterSet, _limitedLength];
            break;
        }
        case WYColatingTextFeildNOEmojiAndSpace:
        {
            if ([textField isFirstResponder]) {
                if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
                    return NO;
                }
                
                NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
                if (![string isEqualToString:tem]) {
                    return NO;
                }
                
                if (textField.text.length >= self.limitedLength) {
                    return NO;
                }
            }
            
            return YES;
            break;
        }
            
        case WYColatingTextFeildNOSpace:
        {
            if ([textField isFirstResponder]) {
                NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
                if (![string isEqualToString:tem]) {
                    return NO;
                }
                
                if (textField.text.length >= self.limitedLength) {
                    return NO;
                }
            }
            return YES;
            break;
        }
    }
    
    NSString *currentText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    return [regexTest evaluateWithObject:currentText] || currentText.length == 0;
}

@end
