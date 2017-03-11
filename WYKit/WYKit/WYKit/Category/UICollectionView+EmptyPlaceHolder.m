//
//  UICollectionView+EmptyPlaceHolder.m
//  WYKit
//
//  Created by 汪年成 on 17/2/6.
//  Copyright © 2017年 之静之初. All rights reserved.
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
