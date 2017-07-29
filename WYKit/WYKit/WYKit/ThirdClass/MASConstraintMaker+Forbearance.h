//
//  WYThirdClass.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "MASConstraintMaker.h"
#import "MASForbearance.h"

@interface MASConstraintMaker (Forbearance) <MASForbearanceDelegate>

@property (nonatomic, strong, readonly) MASForbearance *hugging;
@property (nonatomic, strong, readonly) MASForbearance *compression;
@property (nonatomic, strong, readonly) MASForbearance *compressionResistance;

@property (nonatomic, strong, readonly) MASForbearance *horizontal;
@property (nonatomic, strong, readonly) MASForbearance *vertical;

@end
