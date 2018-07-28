//
//  UITableViewCell+Reusable.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Reusable)

/** 快速注册一个可复用的Cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** 取得Cell所在的TableView */
@property (nonatomic, strong, readonly) UITableView *tableView;

/** 取得Cell所在的indexPath */
@property (nonatomic, strong, readonly) NSIndexPath *indexPathCell;

/** 分割线是否延伸到两端 */
@property (nonatomic, assign, readwrite) BOOL seperatorPinToSupperviewMargins;


@end
