//
//  WYCategoryMacro.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#ifndef WYCategoryMacro_h
#define WYCategoryMacro_h

// 动态Get方法
#define wy_categoryPropertyGet(property) return objc_getAssociatedObject(self, @#property);
// 动态Set方法
#define wy_categoryPropertySet(property) objc_setAssociatedObject(self,@#property, property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

#ifndef WY_RUNTIME_CLASS
#define WY_RUNTIME_CLASS(_name_) \
@interface WY_RUNTIME_CLASS ## _name_ : NSObject @end \
@implementation WY_RUNTIME_CLASS ## _name_ @end
#endif


#endif /* WYCategoryMacro_h */
