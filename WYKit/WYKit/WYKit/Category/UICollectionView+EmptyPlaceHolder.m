//
//  UICollectionView+EmptyPlaceHolder.m
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UICollectionView+EmptyPlaceHolder.h"

@implementation UICollectionView (EmptyPlaceHolder)

- (void) collectionViewDisplayView:(UIView *)displayView ifNecessaryForRowCount:(NSUInteger)rowCount
{
    if (rowCount == 0) {
        self.backgroundView = displayView;
    }
    else {
        self.backgroundView = nil;
    }
}

@end
