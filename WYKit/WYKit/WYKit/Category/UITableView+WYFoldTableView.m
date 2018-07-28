//
//  UITableView+WYFoldTableView.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UITableView+WYFoldTableView.h"
#import <objc/runtime.h>

@implementation UITableView (WYFoldTableView)

#pragma mark - init
+ (void)load
{
#pragma clang diagnostic push
    //    [self swizzInstanceMethod:@selector(_numberOfSections) withMethod:@selector(ww__numberOfSections)];
    [self swizzInstanceMethod:@selector(ww__numberOfRowsInSection:) withMethod:@selector(ww__numberOfRowsInSection:)];
#pragma clang diagnostic pop
}

- (NSInteger)ww__numberOfRowsInSection:(NSInteger)section
{
    if(!self.ww_foldState || !self.ww_foldState){
        return [self ww__numberOfRowsInSection:section];
    }
    
    //根据折叠状态返回行数
    BOOL isFolded = [self isSectionFolded:section];
    return isFolded ? 0 : [self ww__numberOfRowsInSection:section];
}

#pragma mark - getter/setter
static const char WWFoldableKey = '\0';
- (BOOL)isFold
{
    return [objc_getAssociatedObject(self, &WWFoldableKey) boolValue];
}

- (void)setIsFold:(BOOL)isFold
{
    [self willChangeValueForKey:@"isFold"];
    objc_setAssociatedObject(self, &WWFoldableKey, @(isFold), OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"isFold"];
    
    //initialize
    if(isFold && !self.ww_foldState){
        NSMutableSet *foldState = [NSMutableSet set];
        self.ww_foldState = foldState;
    }
    
    //clean up
    if(!isFold){
        [self setWw_foldState:nil];
    }
}

static const char WWFoldStateKey = '\0';
- (NSMutableSet *)ww_foldState
{
    return objc_getAssociatedObject(self, &WWFoldStateKey);
}

- (void)setWw_foldState:(NSMutableSet *)ww_foldState
{
    if(self.isFold && ww_foldState != self.ww_foldState){
        [self willChangeValueForKey:@"ww_foldState"];
        objc_setAssociatedObject(self, &WWFoldStateKey, ww_foldState, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"ww_foldState"];
    }
}

#pragma mark - methods
- (BOOL)isSectionFolded:(NSInteger)section
{
    if(!self.isFold || !self.ww_foldState){
        return NO;
    }
    return [self.ww_foldState containsObject:@(section)];
}

- (void)foldSection:(NSInteger)section fold:(BOOL)fold
{
    if(!self.isFold || !self.ww_foldState){
        return;
    }
    
    NSMutableSet *state = self.ww_foldState;
    if(fold){
        [state addObject:@(section)];
    }else{
        [state removeObject:@(section)];
    }
    self.ww_foldState = state;
    
    @try {
        //防止crash
        [self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    } @catch (NSException *exception) {
        NSLog(@"exception：%@", exception);
        [self reloadData];
    }
}
@end

@implementation NSObject (WWExtension)
+ (void)swizzInstanceMethod:(SEL)methodOrig withMethod:(SEL)methodNew
{
    Method orig = class_getInstanceMethod(self, methodOrig);
    Method new = class_getInstanceMethod(self, methodNew);
    if(orig && new){
        method_exchangeImplementations(orig, new);
    }else{
        NSLog(@"swizz instance method failed: %s", sel_getName(methodOrig));
    }
}

@end
