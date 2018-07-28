//
//  UITableView+WYFoldTableView.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface UITableView (WYFoldTableView)

/** 是否让 tableView 具备折叠功能  默认 NO */
@property (nonatomic, assign) BOOL isFold;

/** 返回某个 section 的折叠状态   YES 折叠 / NO 展开 */
- (BOOL)isSectionFolded:(NSInteger)section;

/** 设置指定 section 的折叠状态  */
- (void)foldSection:(NSInteger)section fold:(BOOL)fold;

@end


@interface NSObject (WWExtension)

/**  方法交换 */
+ (void)swizzInstanceMethod:(SEL)methodOrig withMethod:(SEL)methodNew;

@end
