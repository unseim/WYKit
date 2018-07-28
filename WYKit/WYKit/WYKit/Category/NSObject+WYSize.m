//
//  NSObject+WYSize.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "NSObject+WYSize.h"
#import <CoreText/CoreText.h>

@implementation NSObject (WYSize)
//应用程序的屏幕宽、高
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kWidth  [UIScreen mainScreen].bounds.size.width

// 自适应宽度
- (CGRect)getFrameWithFreeWidth:(CGPoint)origin maxHight:(CGFloat)maxHight{
    
    CGRect frame = CGRectMake(0, 0, 0, 0);
    
    if ([self isKindOfClass:[UILabel class]]) {
        
        UILabel *label = (UILabel *)self;
        
        //计算自适应高度
        CGRect rect = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, maxHight)
                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                            attributes:@{NSFontAttributeName:label.font}
                                               context:nil];
        
        frame = CGRectMake(origin.x, origin.y, rect.size.width, maxHight);
        
    }
    
    if ([self isKindOfClass:[UIButton class]]) {
        
        UIButton *button = (UIButton *)self;
        
        CGRect rect = [button.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, maxHight)
                                                           options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                        attributes:@{NSFontAttributeName:button.titleLabel.font}
                                                           context:nil];
        
        frame = CGRectMake(origin.x, origin.y, rect.size.width, maxHight);
        
    }
    
    return frame;
}


// 自适应高度
- (CGRect)getFrameWithFreeHight:(CGPoint)origin
                      maxWidth:(CGFloat)maxWidth
{
    
    CGRect frame = CGRectMake(0, 0, 0, 0);
    
    if ([self isKindOfClass:[UILabel class]]) {
        
        UILabel *label = (UILabel *)self;
        label.numberOfLines = 0;//无限行
        CGRect rect = [label.text boundingRectWithSize:CGSizeMake(maxWidth,MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                            attributes:@{NSFontAttributeName:label.font}
                                               context:nil];
        
        frame = CGRectMake(origin.x, origin.y, rect.size.width, rect.size.height);
        
    }
    
    if ([self isKindOfClass:[UIButton class]]) {
        
        UIButton *button = (UIButton *)self;
        button.titleLabel.numberOfLines = 0;//无限行
        CGRect rect = [button.titleLabel.text boundingRectWithSize:CGSizeMake(200,MAXFLOAT)
                                                           options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                        attributes:@{NSFontAttributeName:button.titleLabel.font}
                                                           context:nil];
        
        frame = CGRectMake(origin.x, origin.y, rect.size.width, rect.size.height);
        
    }
    
    return frame;
}



// 可调整字间距
- (CGRect)getFrameWithFreeWidth:(CGPoint)origin
                       maxHight:(CGFloat)maxHight
                      textSpace:(CGFloat)textSpace
{
    
    CGRect frame = CGRectMake(0, 0, 0, 0);
    
    if ([self isKindOfClass:[UILabel class]]) {
        
        UILabel *label = (UILabel *)self;
        
        //创建可变字符串属性
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:label.attributedText];
        
        //调整间距
        [attributedString addAttribute:(__bridge NSString *)kCTKernAttributeName value:@(textSpace) range:NSMakeRange(0, attributedString.length)];
        label.attributedText = attributedString;
        
        NSDictionary *attributes = @{NSFontAttributeName:label.font,NSKernAttributeName:@(textSpace)};
        
        
        //计算自适应高度
        CGRect rect = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, maxHight)
                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                            attributes:attributes
                                               context:nil];
        
        frame = CGRectMake(origin.x, origin.y, rect.size.width, maxHight);
        
    }
    
    return frame;
}


// 自适应高度--->可调整字间距和行间距
- (CGRect)getFrameWithFreeHight:(CGPoint)origin
                      maxWidth:(CGFloat)maxWidth
                     textSpace:(CGFloat)textSpace
                     lineSpace:(CGFloat)lineSpace
{
    
    CGRect frame = CGRectMake(0, 0, 0, 0);
    
    if ([self isKindOfClass:[UILabel class]]) {
        
        UILabel *label = (UILabel *)self;
        label.numberOfLines = 0;//无限行
        
        //字间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text attributes:@{NSKernAttributeName:@(textSpace),NSFontAttributeName:label.font}];
        //行间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = lineSpace;
        paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;//从左到右
        
        //给可变的属性字符串 添加段落格式
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, label.text.length)];
        label.attributedText = attributedString;
        
        //设置文本偏移量
        // [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(1) range:NSMakeRange(0, label.text.length)];
        
        //计算自适应高度
        CGRect rect = [label.attributedText boundingRectWithSize:CGSizeMake(maxWidth,MAXFLOAT)
                                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                         context:nil];
        
        
        frame = CGRectMake(origin.x, origin.y, rect.size.width, rect.size.height);
    }
    
    return frame;
}







@end
