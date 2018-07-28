//
//  UICollectionView+DynamicCacheHeightLayoutCell.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface UICollectionView (DynamicCacheHeightLayoutCell)

/**
 *  caculate cell size
 *
 *  @param identifier    cell's reuse identifier
 *  @param indexPath     indexPath
 *  @param configuration fill cell with you feed data
 *
 *  @return the caculated cell's height
 */
- (CGSize)sizeForCellWithIdentifier:(NSString *)identifier
                          indexPath:(NSIndexPath *)indexPath
                      configuration: (void (^)(__kindof UICollectionViewCell *)) configuration;

/**
 *  caculate cell size with a fixed width
 *
 *  @param identifier    cell's reuse identifier
 *  @param indexPath     indexPath
 *  @param fixedWidth    your expect width
 *  @param configuration fill cell with you feed data
 *
 *  @return the caculated cell's height
 */

- (CGSize)sizeForCellWithIdentifier:(NSString *)identifier
                          indexPath:(NSIndexPath *)indexPath
                         fixedWidth:(CGFloat)fixedWidth
                      configuration: (void (^)(__kindof UICollectionViewCell *cell)) configuration;

/**
 *  caculate cell size with fixed height
 *
 *  @param identifier    cell's reuse identifier
 *  @param indexPath     indexPath
 *  @param fixedWidth    your expect height
 *  @param configuration fill cell with you feed data
 *
 *  @return the caculated cell's height
 */

- (CGSize)sizeForCellWithIdentifier:(NSString *)identifier
                          indexPath:(NSIndexPath *)indexPath
                        fixedHeight:(CGFloat)fixedHeight
                      configuration: (void (^)(__kindof UICollectionViewCell *cell)) configuration;

@end
