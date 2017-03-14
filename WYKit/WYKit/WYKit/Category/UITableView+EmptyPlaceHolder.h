//
//  UITableView+EmptyPlaceHolder.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface UITableView (EmptyPlaceHolder)

/** 没有数据的时候TableView显示的View */
- (void)tableViewDisplayView:(UIView *)displayView ifNecessaryForRowCount:(NSUInteger)rowCount;


- (void)tableViewWillDisplayNeccessaryView:(UIView *) view;

@end
