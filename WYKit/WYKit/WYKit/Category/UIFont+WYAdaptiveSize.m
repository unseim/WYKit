//
//  UIFont+WYAdaptiveSize.m
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UIFont+WYAdaptiveSize.h"
#import <objc/runtime.h>

@implementation UIFont (WYAdaptiveSize)

+ (void)load
{
    //获取替换后的类方法
    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
    //获取替换前的类方法
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    //然后交换类方法
    method_exchangeImplementations(newMethod, method);
}


+ (UIFont *)adjustFont:(CGFloat)fontSize
{
    UIFont *newFont = nil;
    newFont = [UIFont adjustFont:fontSize * [UIScreen mainScreen].bounds.size.width/KUIScreen];
    return newFont;
}

@end
