//
//  UICollectionView+DynamicCacheHeightLayoutCell.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UICollectionView+DynamicCacheHeightLayoutCell.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, DynamicSizeCaculateType) {
    
    DynamicSizeCaculateTypeSize = 0,
    DynamicSizeCaculateTypeHeight,
    DynamicSizeCaculateTypeWidth
    
};

#define kLayoutCellInvalidateValue [NSValue valueWithCGSize:CGSizeZero]

@implementation UICollectionView (DynamicCacheHeightLayoutCell)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzlingMethods];
    });
}

+ (void)swizzlingMethods {
    SEL selectors[] = {
        @selector(registerNib:forCellWithReuseIdentifier:),
        @selector(registerClass:forCellWithReuseIdentifier:),
        @selector(reloadData),
        @selector(reloadSections:),
        @selector(deleteSections:),
        @selector(moveSection:toSection:),
        @selector(reloadItemsAtIndexPaths:),
        @selector(deleteItemsAtIndexPaths:),
        @selector(moveItemAtIndexPath:toIndexPath:)
    };
    
    for (int i = 0; i < sizeof(selectors) / sizeof(SEL); i++) {
        SEL originalSelector = selectors[i];
        SEL swizzledSelector = NSSelectorFromString([@"wy_"
                                                     stringByAppendingString:NSStringFromSelector(originalSelector)]);
        
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (CGSize)sizeForCellWithIdentifier:(NSString *)identifier
                          indexPath:(NSIndexPath *)indexPath
                      configuration: (void (^)(__kindof UICollectionViewCell *)) configuration {
    
    return [self sizeForCellWithIdentifier:identifier
                                 indexPath:indexPath
                                fixedValue:0
                              caculateType:DynamicSizeCaculateTypeSize
                             configuration:configuration];
}

- (CGSize)sizeForCellWithIdentifier:(NSString *)identifier
                          indexPath:(NSIndexPath *)indexPath
                         fixedWidth:(CGFloat)fixedWidth
                      configuration: (void (^)(__kindof UICollectionViewCell *)) configuration {
    
    return [self sizeForCellWithIdentifier:identifier
                                 indexPath:indexPath
                                fixedValue:fixedWidth
                              caculateType:DynamicSizeCaculateTypeWidth
                             configuration:configuration];
}

- (CGSize)sizeForCellWithIdentifier:(NSString *)identifier
                          indexPath:(NSIndexPath *)indexPath
                        fixedHeight:(CGFloat)fixedHeight
                      configuration: (void (^)(__kindof UICollectionViewCell *)) configuration {
    
    return [self sizeForCellWithIdentifier:identifier
                                 indexPath:indexPath
                                fixedValue:fixedHeight
                              caculateType:DynamicSizeCaculateTypeHeight
                             configuration:configuration];
}

- (CGSize)sizeForCellWithIdentifier:(NSString *)identifier
                          indexPath:(NSIndexPath *)indexPath
                         fixedValue:(CGFloat)fixedValue
                       caculateType:(DynamicSizeCaculateType)caculateType
                      configuration: (void (^)(__kindof UICollectionViewCell *)) configuration {
    
    BOOL hasCache = [self hasCacheAtIndexPath:indexPath];
    if (hasCache) {
        if (![[self sizeCacheAtIndexPath:indexPath]
              isEqualToValue:kLayoutCellInvalidateValue]) {
            return [[self sizeCacheAtIndexPath:indexPath] CGSizeValue];
        }
    }
    
    // has no size chche
    UICollectionViewCell *cell =
    [self templeCaculateCellWithIdentifier:identifier];
    configuration(cell);
    CGSize size = CGSizeMake(fixedValue, fixedValue);
    if (caculateType != DynamicSizeCaculateTypeSize) {
        NSLayoutAttribute attribute = caculateType == DynamicSizeCaculateTypeWidth
        ? NSLayoutAttributeWidth
        : NSLayoutAttributeHeight;
        NSLayoutConstraint *tempConstraint =
        [NSLayoutConstraint constraintWithItem:cell.contentView
                                     attribute:attribute
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1
                                      constant:fixedValue];
        [cell.contentView addConstraint:tempConstraint];
        size = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [cell.contentView removeConstraint:tempConstraint];
    } else {
        size = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    }
    
    NSMutableArray *sectionCache = [self sizeCache][indexPath.section];
    NSValue *sizeValue = [NSValue valueWithCGSize:size];
    if (hasCache) {
        [sectionCache replaceObjectAtIndex:indexPath.row withObject:sizeValue];
    } else {
        [sectionCache insertObject:sizeValue atIndex:indexPath.row];
    }
    return size;
}

#pragma mark - swizzled methods

- (void)wy_registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self wy_registerClass:cellClass forCellWithReuseIdentifier:identifier];
    
    id cell = [[cellClass alloc] initWithFrame:CGRectZero];
    NSMutableDictionary *templeCells = [self templeCells];
    templeCells[identifier] = cell;
}

- (void)wy_registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier {
    [self wy_registerNib:nib forCellWithReuseIdentifier:identifier];
    id cell = [[nib instantiateWithOwner:nil options:nil] lastObject];
    NSMutableDictionary *templeCells = [self templeCells];
    templeCells[identifier] = cell;
}

#pragma mark - section changes

- (void)wy_reloadSections:(NSIndexSet *)sections {
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        if (idx < [self sizeCache].count) {
            [[self sizeCache] replaceObjectAtIndex:idx withObject:@[].mutableCopy];
        }
    }];
    [self wy_reloadSections:sections];
}

- (void)wy_deleteSections:(NSIndexSet *)sections {
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        if (idx < [self sizeCache].count) {
            [[self sizeCache] removeObjectAtIndex:idx];
        }
    }];
    [self wy_deleteSections:sections];
}

- (void)wy_moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    if (section < [self sizeCache].count && newSection < [self sizeCache].count) {
        [[self sizeCache] exchangeObjectAtIndex:section withObjectAtIndex:newSection];
    }
    [self wy_moveSection:section toSection:newSection];
}

#pragma mark - item changes

- (void)wy_deleteItemsAtIndexPaths:(NSArray *)indexPaths {
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *obj, NSUInteger idx,
                                             BOOL *stop) {
        if ([self.sizeCache count] > obj.section) {
            NSMutableArray *section = [self sizeCache][obj.section];
            [section removeObjectAtIndex:obj.row];
        }
    }];
    [self wy_deleteItemsAtIndexPaths:indexPaths];
}

- (void)wy_reloadItemsAtIndexPaths:(NSArray *)indexPaths {
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *obj, NSUInteger idx,
                                             BOOL *stop) {
        if ([self.sizeCache count] > obj.section) {
            NSMutableArray *section = [self sizeCache][obj.section];
            section[obj.row] = kLayoutCellInvalidateValue;
        }
    }];
    [self wy_reloadItemsAtIndexPaths:indexPaths];
}

- (void)wy_moveItemAtIndexPath:(NSIndexPath *)indexPath
                   toIndexPath:(NSIndexPath *)newIndexPath {
    if ([self hasCacheAtIndexPath:indexPath] &&
        [self hasCacheAtIndexPath:newIndexPath]) {
        NSValue *indexPathSizeValue = [self sizeCacheAtIndexPath:indexPath];
        NSValue *newIndexPathSizeValue = [self sizeCacheAtIndexPath:newIndexPath];
        
        NSMutableArray *section1 = [self sizeCache][indexPath.section];
        NSMutableArray *section2 = [self sizeCache][newIndexPath.section];
        [section1 replaceObjectAtIndex:indexPath.row
                            withObject:newIndexPathSizeValue];
        [section2 replaceObjectAtIndex:newIndexPath.row
                            withObject:indexPathSizeValue];
    }
    [self wy_moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
}

- (void)wy_reloadData {
    [[self sizeCache] removeAllObjects];
    [self wy_reloadData];
}

#pragma mark - private methods

- (NSMutableDictionary *)templeCells {
    NSMutableDictionary *templeCells = objc_getAssociatedObject(self, _cmd);
    if (templeCells == nil) {
        templeCells = @{}.mutableCopy;
        objc_setAssociatedObject(self, _cmd, templeCells,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return templeCells;
}

- (id)templeCaculateCellWithIdentifier:(NSString *)identifier {
    NSMutableDictionary *templeCells = [self templeCells];
    id cell = [templeCells objectForKey:identifier];
    if (cell == nil) {
        NSDictionary *cellNibDict = [self valueForKey:@"_cellNibDict"];
        UINib *cellNIb = cellNibDict[identifier];
        cell = [[cellNIb instantiateWithOwner:nil options:nil] lastObject];
        templeCells[identifier] = cell;
    }
    
    return cell;
}

#pragma mark - cache methods

- (NSMutableArray *)sizeCache {
    NSMutableArray *cache = objc_getAssociatedObject(self, _cmd);
    if (cache == nil) {
        cache = @[].mutableCopy;
        objc_setAssociatedObject(self, _cmd, cache, OBJC_ASSOCIATION_RETAIN);
    }
    return cache;
}

- (BOOL)hasCacheAtIndexPath:(NSIndexPath *)indexPath {
    BOOL hasCache = NO;
    NSMutableArray *cacheArray = [self sizeCache];
    if (cacheArray.count > indexPath.section) {
        if ([cacheArray[indexPath.section] count] > indexPath.row) {
            hasCache = YES;
        }
    } else {
        NSUInteger index = cacheArray.count;
        for (; index < indexPath.section + 1; index++) {
            [cacheArray addObject:@[].mutableCopy];
        }
    }
    
    return hasCache;
}

- (NSValue *)sizeCacheAtIndexPath:(NSIndexPath *)indexPath {
    NSValue *sizeValue = [self sizeCache][indexPath.section][indexPath.row];
    return sizeValue;
}

@end
