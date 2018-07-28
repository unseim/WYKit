//
//  NSMutableArray+WYKit.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (WYKit)

#pragma 增加或删除对象

/** 插入一个元素到指定位置 */
- (void)insertObject:(id)object atIndexIfNotNil:(NSUInteger)index;

/** 移动对象 从一个位置到另一个位置 */
- (void)moveObjectAtIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex;


#pragma mark - 排序

/** 重组数组(打乱顺序) */
- (void)shuffle;

/** 数组倒序 */
- (void)reverse;

/** 数组去除相同的元素 */
- (void)unique;

/** 根据关键词 对本数组的内容进行排序  YES 升序 NO 降序  */
- (void)sorting:(NSString *)parameters ascending:(BOOL)ascending;

#pragma - mark 安全操作

/** 添加新对象 */
- (void)addObj:(id)i;

/** 添加字符串 */
- (void)addString:(NSString*)i;

/** 添加Bool */
- (void)addBool:(BOOL)i;

/** 添加Int */
- (void)addInt:(int)i;

/** 添加Integer */
- (void)addInteger:(NSInteger)i;

/** 添加UnsignedInteger */
- (void)addUnsignedInteger:(NSUInteger)i;

/** 添加CGFloat */
- (void)addCGFloat:(CGFloat)f;

/** 添加Char */
- (void)addChar:(char)c;

/** 添加Float */
- (void)addFloat:(float)i;

/** 添加Point */
- (void)addPoint:(CGPoint)o;

/** 添加Size */
- (void)addSize:(CGSize)o;

/** 添加Rect */
- (void)addRect:(CGRect)o;

@end
