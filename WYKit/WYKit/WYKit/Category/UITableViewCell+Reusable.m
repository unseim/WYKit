//
//  UITableViewCell+Reusable.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UITableViewCell+Reusable.h"

@implementation UITableViewCell (Reusable)


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)];
    if (!cell) {
        NSString *path = [[NSBundle mainBundle] pathForResource:NSStringFromClass(self.class) ofType:@"nib"];
        if (path.length) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil] firstObject];
            [cell setValue:NSStringFromClass(self.class) forKey:@"reuseIdentifier"];
        } else {
            cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self.class)];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}








#pragma mark - 属性

- (UITableView *)tableView
{
    UIView *aView = self.superview;
    while (aView != nil) {
        if ([aView isKindOfClass:[UITableView class]]) {
            return (UITableView *)aView;
        }
        aView = aView.superview;
    }
    return nil;
}

- (NSIndexPath *)indexPathCell
{
    return [self.tableView indexPathForCell:self];
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)setTableView:(UITableView *)tableView
{
    
}

- (BOOL)seperatorPinToSupperviewMargins
{
    return NO;
}

- (void)setSeperatorPinToSupperviewMargins:(BOOL)seperatorPinToSupperviewMargins
{
    if (seperatorPinToSupperviewMargins) {
        UITableView *tableView = self.tableView;
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}


@end
