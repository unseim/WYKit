//
//  UILabel+ContentSize.h
//  WYKit
//
//  Created by 汪年成 on 16/12/23.
//  Copyright © 2016年 之静之初. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ContentSize)

- (CGSize)contentSizeForWidth:(CGFloat)width;

- (CGSize)contentSize;

- (BOOL)isTruncated;

@end
