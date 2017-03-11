//
//  WYColatingTextView.m
//  WYKit
//
//  Created by 汪年成 on 17/1/19.
//  Copyright © 2017年 之静之初. All rights reserved.
//

#import "WYColatingTextView.h"

@interface WYColatingTextView ()
@property (weak, nonatomic, readonly) UITextView *textView;
@property (weak, nonatomic, readonly) UIViewController *viewController;

@end

@implementation WYColatingTextView

- (instancetype)initWithTextView:(UITextView *)textview controller:(UIViewController *)viewController {
    if (self = [self init]) {
        textview.delegate = self;
        _textView = textview;
        _viewController = viewController;
        _textViewType = WYColatingTextViewAny;
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
                                                selector:@selector(textViewEditChanged:)
                                                    name:UITextViewTextDidChangeNotification
                                                  object:nil];
    }
}

-(void)textViewEditChanged:(NSNotification *)obj {
    UITextView *textView = self.textView;
    
    NSInteger length_cn = 0;
    NSInteger length_en = 0;
    
    length_cn = _cnInt;
    length_en = _enInt;
    
    NSString *toBeString = textView.text;
    
    //中英占位比例
    CGFloat scale = (CGFloat)length_en/(CGFloat)length_cn;
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
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
                    textView.text = [toBeString substringToIndex:length_cn];
                }else if (cnNum == 0 ) {
                    ///纯英文
                    textView.text = [toBeString substringToIndex:length_en];
                }else {
                    ///中英文
                    textView.text = [toBeString substringToIndex:cnNum + enNum - 1];
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




//      不起作用  待解决 。。。
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        NSLog(@"换行符");
        
        [textView resignFirstResponder];
        
        return NO; 
        
    }
    
    return YES; 
    
}


/*
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"好气哦");
    if ([_viewController respondsToSelector:@selector(formatter:textViewDidBeginEditing:)]) {
        [_viewController performSelector:@selector(formatter:textViewDidBeginEditing:) withObject:self withObject:text];
    }
    
    NSString *regexString;
    switch (_textViewType) {
        case WYColatingTextViewAny:
        {
            return YES;
        }
        case WYColatingTextViewOnlyPhoneNumber:
        {
            regexString = @"^\\d{0,11}$";
            break;
        }
        case WYColatingTextViewOnlyNumber:
        {
            regexString = @"^\\d*$";
            break;
        }
        case WYColatingTextViewOnlyDecimal:
        {
            regexString = [NSString stringWithFormat:@"^(\\d+)\\.?(\\d{0,%lu})$", _decimalPlace];
            break;
        }
        case WYColatingTextViewOnlyAlphabet:
        {
            regexString = @"^[a-zA-Z]*$";
            break;
        }
        case WYColatingTextViewOnlyNumberAndAlphabet:
        {
            regexString = @"^[a-zA-Z0-9]*$";
            break;
        }
        case WYColatingTextViewOnlyIDCard:
        {
            regexString = @"^\\d{1,17}[0-9Xx]?$";
            break;
        }
        case WYColatingTextViewOnlyCustom:
        {
            regexString = [NSString stringWithFormat:@"^[%@]{0,%lu}$", _characterSet, _limitedLength];
            break;
        }
        case WYColatingTextViewNOEmojiAndSpace:
        {
            NSLog(@"可执行到");
            if ([textView isFirstResponder]) {
                if ([self stringContainsEmoji:text]) {
                    return NO;
                }
                
                
                NSString *tem = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
                if (![text isEqualToString:tem]) {
                    return NO;
                }
                
                if (textView == self.textView) {
                    if (textView.text.length >= self.limitedLength) return NO;
                }
                
            }
            return YES;
            
            break;
        }
            
        case WYColatingTextViewNOSpace:
        {
            if ([textView isFirstResponder]) {
                NSString *tem = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
                if (![text isEqualToString:tem]) {
                    return NO;
                }
                
                if (textView == self.textView) {
                    if (textView.text.length >= self.limitedLength) return NO;
                }
                
            }
            return YES;
            break;
        }
            
            
    }
    NSString *currentText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    
    return [regexTest evaluateWithObject:currentText] || currentText.length == 0;
}
 */
 
/*
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"textViewShouldBeginEditing");
    if ([_viewController respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [_viewController performSelector:@selector(textViewShouldBeginEditing:) withObject:textView];
    }
    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"操");
    if ([_viewController respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [_viewController performSelector:@selector(textViewDidBeginEditing:) withObject:textView];
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    NSLog(@"textViewShouldEndEditing");
    if ([_viewController respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [_viewController performSelector:@selector(textViewShouldEndEditing:) withObject:textView];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
     NSLog(@"textViewDidEndEditing");
    if ([_viewController respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [_viewController performSelector:@selector(textViewDidEndEditing:) withObject:textView];
    }
}

*/





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
     * 133,1349,153,180,189,177,181(增加)
     */
    NSString * CT = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
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
    
    if (([regextestmobile evaluateWithObject:self.textView.text] == YES)
        || ([regextestcm evaluateWithObject:self.textView.text] == YES)
        || ([regextestct evaluateWithObject:self.textView.text] == YES)
        || ([regextestcu evaluateWithObject:self.textView.text] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
