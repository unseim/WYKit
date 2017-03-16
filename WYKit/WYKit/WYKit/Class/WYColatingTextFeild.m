//
//  WYColatingTextFeild.m
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYColatingTextFeild.h"

@interface WYColatingTextFeild ()
@property (weak, nonatomic, readonly) UIViewController *viewController;
@property (weak, nonatomic, readonly) UITextField *field;

@end

@implementation WYColatingTextFeild

- (instancetype)initWithTextField:(UITextField *)textField controller:(UIViewController *)viewController {
    if (self = [self init]) {
        textField.delegate = self;
        _field = textField;
        _viewController = viewController;
        _textFeildType = WYColatingTextFeildAny;
        _limitedLength = INT16_MAX;
        _characterSet = @"";
        _cnInt = INT16_MAX;
        _enInt = INT16_MAX;
        _decimalPlace = 1;
    }
    return self;
}

-(void)setIsWordLimit:(BOOL)isWordLimit
{
    if (isWordLimit == YES) {
        ///字数改变
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(textFiledEditChanged:)
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:nil];
    }
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = self.field;
    
    NSInteger length_cn = 0;
    NSInteger length_en = 0;
    
    length_cn = _cnInt;
    length_en = _enInt;
    
    NSString *toBeString = textField.text;
    
    //中英占位比例
    CGFloat scale = (CGFloat)length_en/(CGFloat)length_cn;
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
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
                    textField.text = [toBeString substringToIndex:length_cn];
                }else if (cnNum == 0 ) {
                    ///纯英文
                    textField.text = [toBeString substringToIndex:length_en];
                }else {
                    ///中英文
                    textField.text = [toBeString substringToIndex:cnNum + enNum - 1];
                }
                return;
            }
            
        }
        
    }
    // 有高亮选择的字符串，则暂不对文字进行统计和限制
    else{
        
    }
    
}


-(void)setCnInt:(NSInteger)cnInt
{
    _cnInt = cnInt;
}

-(void)setEnInt:(NSInteger)enInt
{
    _enInt = enInt;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if ([_viewController respondsToSelector:@selector(formatter:didEnterCharacter:)]) {
//        [_viewController performSelector:@selector(formatter:didEnterCharacter:) withObject:self withObject:string];
//    }
    
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
                
//                if ([self stringContainsEmoji:string]) {
//                    return NO;
//                }
                
                NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
                if (![string isEqualToString:tem]) {
                    return NO;
                }
                
                if (textField == self.field) {
                    if (textField.text.length >= self.limitedLength) return NO;
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
                
                if (textField == self.field) {
                    if (textField.text.length >= self.limitedLength) return NO;
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([_viewController respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [_viewController performSelector:@selector(textFieldShouldBeginEditing:) withObject:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([_viewController respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [_viewController performSelector:@selector(textFieldDidBeginEditing:) withObject:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([_viewController respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [_viewController performSelector:@selector(textFieldShouldEndEditing:) withObject:textField];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([_viewController respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_viewController performSelector:@selector(textFieldDidEndEditing:) withObject:textField];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([_viewController respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [_viewController performSelector:@selector(textFieldShouldClear:) withObject:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_viewController respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [_viewController performSelector:@selector(textFieldShouldReturn:) withObject:textField];
    }
    return YES;
}

- (BOOL)isValidPhone
{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189,177,173,181(增加)
     */
    NSString * CT = @"^((133)|(153)|(17[7,3])|(18[0,1,9]))\\d{8}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self.field.text] == YES)
        || ([regextestcm evaluateWithObject:self.field.text] == YES)
        || ([regextestct evaluateWithObject:self.field.text] == YES)
        || ([regextestcu evaluateWithObject:self.field.text] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (BOOL)stringContainsEmoji:(NSString *)string
{
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

@end
