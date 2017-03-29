//
//  NSArray+WYKit.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

@interface NSArray (WYKit)

#pragma mark - 取值

/** 随机取数组里的一个元素 */
- (instancetype)randomObject;

#pragma mark - 数组转字符串

/** 数组转字符串 */
- (NSString *)string;

#pragma mark - 数组计算交集和差集

/** 数组计算交集 */
- (NSArray *)arrayForIntersectionWithOtherArray:(NSArray *)otherArray;

/** 数组计算差集 */
- (NSArray *)arrayForMinusWithOtherArray:(NSArray *)otherArray;

#pragma mark - 排序

/** 重组数组(打乱顺序) */
- (NSArray *)shuffledArray;

/** 数组倒序 */
- (NSArray *)reversedArray;

/** 数组去除相同的元素，并获得新的array */
- (NSArray *)uniqueArray;

/** 根据关键词 对array的内容进行排序，并返回排序后的array */
- (NSArray *)arraySorting:(NSString *)parameters  ascending:(BOOL)ascending;


#pragma mark - 安全操作

/** 获取下标为index的对象 */
- (instancetype)objectWithIndex:(NSUInteger)index;

/** 获取下标为index的字符串，不存在返回空，能转为string的转，不能的返回nil */
- (NSString *)stringWithIndex:(NSUInteger)index;

/** 获取下标为index的number，不存在返回空，能转为number的转，不能的返回nil */
- (NSNumber *)numberWithIndex:(NSUInteger)index;

/** 获取下标为index的array，不存返回nil */
- (NSArray *)arrayWithIndex:(NSUInteger)index;

/** 获取下标为index的Dictionary，不存返回nil */
- (NSDictionary *)dictionaryWithIndex:(NSUInteger)index;

/** 获取下标为index的integer，不存返回0 */
- (NSInteger)integerWithIndex:(NSUInteger)index;

/** 获取下标为index的unsignedInteger，不存返回0 */
- (NSUInteger)unsignedIntegerWithIndex:(NSUInteger)index;

/** 获取下标为index的bool，不存返回NO */
- (BOOL)boolWithIndex:(NSUInteger)index;

/** 获取下标为index的int16，不存返回0 */
- (int16_t)int16WithIndex:(NSUInteger)index;

/** 获取下标为index的int32，不存返回0 */
- (int32_t)int32WithIndex:(NSUInteger)index;

/** 获取下标为index的int64，不存返回0 */
- (int64_t)int64WithIndex:(NSUInteger)index;

/** 获取下标为index的charValue，不存返回0 */
- (char)charWithIndex:(NSUInteger)index;

/** 获取下标为index的intValue，不存返回0 */
- (short)shortWithIndex:(NSUInteger)index;

/** 获取下标为index的floatValue，不存返回0 */
- (float)floatWithIndex:(NSUInteger)index;

/** 获取下标为index的doubleValue，不存返回0 */
- (double)doubleWithIndex:(NSUInteger)index;

/** 获取下标为index的CGFloat */
- (CGFloat)CGFloatWithIndex:(NSUInteger)index;

/** 获取下标为index的point */
- (CGPoint)pointWithIndex:(NSUInteger)index;

/** 获取下标为index的size */
- (CGSize)sizeWithIndex:(NSUInteger)index;

/** 获取下标为index的rect */
- (CGRect)rectWithIndex:(NSUInteger)index;


@end
