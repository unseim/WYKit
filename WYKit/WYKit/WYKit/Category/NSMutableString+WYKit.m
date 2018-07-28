//
//  NSMutableString+WYKit.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "NSMutableString+WYKit.h"
#import "WYCategoryMacro.h"

WY_RUNTIME_CLASS(NSMutableString_WYKit)
@implementation NSMutableString (WYKit)

//  替换字符串
- (void)replaceString:(NSString *)searchString withString:(NSString *)newString
{
    NSRange range = [self rangeOfString:searchString];
    [self replaceCharactersInRange:range withString:newString];
}

//  去除空格
- (void)removeSpace
{
    [self replaceString:@" " withString:@""];
}

//  将字符串中“Nil”和“Null”去除
- (void)removeNilAndNull
{
    if ([self isEqual:[NSNull null]]| (self == nil)) {
        [self setString:@""];
    }
}

@end
