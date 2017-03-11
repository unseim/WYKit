//
//  UITextView+Uitls.m
//  WYKit
//
//  Created by 汪年成 on 16/12/22.
//  Copyright © 2016年 之静之初. All rights reserved.
//

#import "UITextView+Uitls.h"

@implementation UITextView (Uitls)
// 设置行距及字体大小
- (void)setText:(NSString*)text fontSize:(CGFloat)size lineSpacing:(CGFloat)lineSpacing {
    if (lineSpacing < 0.01 || !text) {
        self.text = text;
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, [attributedString length])];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    
    self.attributedText = attributedString;
}



@end
