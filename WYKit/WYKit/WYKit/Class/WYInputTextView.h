//
//  WYInputTextView.h
//  WYKit
//
//  Created by Developer_wnc on 2018/7/28.
//  Copyright © 2018年 之静之初. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYInputTextView;

@protocol WYInputTextViewDelegate <NSObject>
@optional

/** 当textView点击return */
- (void)textViewReturnKeyPress:(WYInputTextView *)textView;

/** 当textView文字发生改变 */
- (void)wyTextViewDidChange:(WYInputTextView *)textView;

@end


/** 当超出最大限制字符后的操作 */
typedef NS_ENUM(NSInteger, WYInputTextViewType) {
    
    WYInputDefault            = 0,       //  不做任何处理
    WYInputInterceptionString = 1 << 0,  //  截取字符串
    WYInputUnableToEnter      = 1 << 1,  //  无法输入
    
};

@interface WYInputTextView : UITextView

@property (nonatomic, weak) id<WYInputTextViewDelegate> sendDelegate;


/** 能够输入的最大字符串长度 */
@property (nonatomic, assign) NSInteger MaxWordNumber;

/** 长度限制样式 */
@property (nonatomic, assign) WYInputTextViewType inputType; // default is WYInputInterceptionString

/** 是否筛除emoji表情 */
@property (nonatomic, assign) BOOL isEmoticons;     // default is NO

/** 输入内容的起始坐标 */
@property (nonatomic, assign) CGPoint   textPoint;   // default is (5,5)

/** 可输入字数 */
@property (nonatomic, assign) NSInteger canEnterWordsNumber;


/** 获取光标位置 */
- (NSRange)selectedRange;

/** 设置光标位置 */
- (void)setSelectedRange:(NSRange) range;

@end
