//
//  UICollectionView+EmptyPlaceHolder.h
//  WYKit
//
//  Created by 汪年成 on 17/2/6.
//  Copyright © 2017年 之静之初. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (EmptyPlaceHolder)

/**
 *  没有数据的时候CollectionView显示的View
 */
- (void)collectionViewDisplayView:(UIView *)displayView ifNecessaryForRowCount:(NSUInteger)rowCount;

@end
