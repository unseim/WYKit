//
//  WYColatingTextView.m
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
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









@end
