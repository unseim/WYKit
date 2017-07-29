//
//  UITableView+EmptyPlaceHolder.m
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
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


@end
