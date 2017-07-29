//
//  WYThirdClass.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "MASForbearance.h"

@implementation MASForbearance

- (MASForbearance *)hugging {
    return [self.delegate forbearance:self addForbearanceRule:(MASForbearanceRuleHugging)];
}
- (MASForbearance *)compression {
    return [self.delegate forbearance:self addForbearanceRule:(MASForbearanceRuleCompression)];
}
- (MASForbearance *)compressionResistance {
    return [self.delegate forbearance:self addForbearanceRule:(MASForbearanceRuleCompression)];
}

- (MASForbearance *)horizontal {
    return [self.delegate forbearance:self addForbearanceRule:(MASForbearanceRuleHorizontal)];
}
- (MASForbearance *)vertical {
    return [self.delegate forbearance:self addForbearanceRule:(MASForbearanceRuleVertical)];
}

- (MASForbearance *(^)(MASLayoutPriority))priority {
    return ^id(MASLayoutPriority priority) {
        return [self.delegate forbearance:self priority:priority];
    };
}
- (MASForbearance *(^)())priorityRequired {
    return ^id{
        return self.priority(MASLayoutPriorityRequired);
    };
}
- (MASForbearance *(^)())priorityHigh {
    return ^id{
        return self.priority(MASLayoutPriorityDefaultHigh);
    };
}
- (MASForbearance *(^)())priorityMedium {
    return ^id{
        return self.priority(MASLayoutPriorityDefaultMedium);
    };
}
- (MASForbearance *(^)())priorityLow {
    return ^id{
        return self.priority(MASLayoutPriorityDefaultLow);
    };
}
- (MASForbearance *(^)())priorityFittingSizeLevel {
    return ^id{
        return self.priority(MASLayoutPriorityFittingSizeLevel);
    };
}
@end
