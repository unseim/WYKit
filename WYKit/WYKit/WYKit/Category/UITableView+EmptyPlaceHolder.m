//
//  UITableView+EmptyPlaceHolder.m
//  WYKit
//
//  Created by 汪年成 on 17/2/6.
//  Copyright © 2017年 之静之初. All rights reserved.
//

#import "UITableView+EmptyPlaceHolder.h"
#import <objc/runtime.h>

@implementation UITableView (EmptyPlaceHolder)

- (void)tableViewDisplayView:(UIView *) displayView ifNecessaryForRowCount:(NSUInteger)rowCount
{
    if (rowCount == 0) {
        self.backgroundView = displayView;
        self.scrollEnabled = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else {
        self.backgroundView = nil;
        self.scrollEnabled = YES;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}


- (void) tableViewWillDisplayNeccessaryView:(UIView *) view
{
    
}

@end
