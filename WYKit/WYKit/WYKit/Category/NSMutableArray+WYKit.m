//
//  NSMutableArray+WYKit.m
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//
#import "NSMutableArray+WYKit.h"
#import "WYCategoryMacro.h"

WY_RUNTIME_CLASS(NSMutableArray_WYKit)
@implementation NSMutableArray (WYKit)

#pragma 增加或删除对象

- (void)insertObject:(id)object atIndexIfNotNil:(NSUInteger)index
{
    if (self.count > index && object) {
        [self insertObject:object atIndex:index];
    }
}

- (void)moveObjectAtIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex
{
    if (self.count > index && self.count > toIndex) {
        id object = [self objectAtIndex:index];
        if (index > toIndex) {
            [self removeObjectAtIndex:index];
            [self insertObject:object atIndex:toIndex];
        } else if (index < toIndex) {
            [self removeObjectAtIndex:index];
            [self insertObject:object atIndex:toIndex - 1];
        }
    }
}


#pragma mark - 排序

- (void)shuffle
{
    NSMutableArray *copy = [self mutableCopy];
    [self removeAllObjects];
    while ([copy count] > 0) {
        int index = arc4random() % [copy count];
        id objectToMove = [copy objectAtIndex:index];
        [self addObject:objectToMove];
        [copy removeObjectAtIndex:index];
    }
}

- (void)reverse
{
    NSArray *reversedArray = [[self reverseObjectEnumerator] allObjects];
    [self removeAllObjects];
    [self addObjectsFromArray:reversedArray];
}

- (void)unique
{
    NSSet *set = [NSSet setWithArray:self];
    NSArray *array = [[NSArray alloc] initWithArray:[set allObjects]];
    [self removeAllObjects];
    [self addObjectsFromArray:array];
}

- (void)sorting:(NSString *)parameters ascending:(BOOL)ascending
{
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc]initWithKey:parameters ascending:ascending];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc]initWithObjects:&sorter count:1];
    NSArray *sortArray=[self sortedArrayUsingDescriptors:sortDescriptors];
    [self removeAllObjects];
    [self addObjectsFromArray:sortArray];
}


#pragma mark - 安全操作

-(void)addObj:(id)i
{
    if (i!=nil) {
        [self addObject:i];
    }
}

-(void)addString:(NSString*)i
{
    if (i!=nil) {
        [self addObject:i];
    }
}

- (void)addBool:(BOOL)i
{
    [self addObject:@(i)];
}

- (void)addInt:(int)i
{
    [self addObject:@(i)];
}

- (void)addInteger:(NSInteger)i
{
    [self addObject:@(i)];
}

- (void)addUnsignedInteger:(NSUInteger)i
{
    [self addObject:@(i)];
}

- (void)addCGFloat:(CGFloat)f
{
    [self addObject:@(f)];
}

- (void)addChar:(char)c
{
    [self addObject:@(c)];
}

- (void)addFloat:(float)i
{
    [self addObject:@(i)];
}

- (void)addPoint:(CGPoint)o
{
    [self addObject:NSStringFromCGPoint(o)];
}

- (void)addSize:(CGSize)o
{
    [self addObject:NSStringFromCGSize(o)];
}

- (void)addRect:(CGRect)o
{
    [self addObject:NSStringFromCGRect(o)];
}

@end
