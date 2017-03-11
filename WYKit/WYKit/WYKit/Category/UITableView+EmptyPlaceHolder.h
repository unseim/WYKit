//
//  UITableView+EmptyPlaceHolder.h
//  WYKit
//
//  Created by 汪年成 on 17/2/6.
//  Copyright © 2017年 之静之初. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EmptyPlaceHolder)

/**
 *  没有数据的时候TableView显示的View
 */
- (void)tableViewDisplayView:(UIView *)displayView ifNecessaryForRowCount:(NSUInteger)rowCount;


- (void)tableViewWillDisplayNeccessaryView:(UIView *) view;

@end
