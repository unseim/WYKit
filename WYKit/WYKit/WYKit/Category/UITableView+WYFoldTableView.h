//
//  UITableView+WYFoldTableView.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface UITableView (WYFoldTableView)

/** 设置 YES 让tableView具备折叠功能  默认 NO */
@property (assign, nonatomic) BOOL isFold;

/** 返回某个section的折叠状态   YES 折叠 / NO 展开 */
- (BOOL)isSectionFolded:(NSInteger)section;

/** 设置指定section的折叠状态  */
- (void)foldSection:(NSInteger)section fold:(BOOL)fold;

@end


@interface NSObject (WWExtension)

//  方法交换
+ (void)swizzInstanceMethod:(SEL)methodOrig withMethod:(SEL)methodNew;

+ (void)swizzClassMethod:(SEL)methodOrig withMethod:(SEL)methodNew;


@end
