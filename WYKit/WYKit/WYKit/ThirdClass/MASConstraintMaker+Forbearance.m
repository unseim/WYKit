//
//  WYThirdClass.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "MASConstraintMaker+Forbearance.h"
#import <objc/runtime.h>


@interface MASConstraintMaker ()

@property (nonatomic, strong) NSNumber *forbearanceRules;

@end

@implementation MASConstraintMaker (Forbearance)

static NSString *ForbearanceRulesKey = @"Mark.By.Star.ForbearanceRules";
- (NSNumber *)forbearanceRules {
    return objc_getAssociatedObject(self, &ForbearanceRulesKey);
}
- (void)setForbearanceRules:(NSNumber *)forbearanceRules {
    objc_setAssociatedObject(self, &ForbearanceRulesKey, forbearanceRules, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (MASForbearance *)hugging {
    MASForbearance *forbearance = MASForbearance.new;
    forbearance.delegate = self;
    return forbearance.hugging;
}
- (MASForbearance *)compression {
    MASForbearance *forbearance = MASForbearance.new;
    forbearance.delegate = self;
    return forbearance.compression;
}
- (MASForbearance *)compressionResistance {
    MASForbearance *forbearance = MASForbearance.new;
    forbearance.delegate = self;
    return forbearance.compressionResistance;
}


- (MASForbearance *)horizontal {
    MASForbearance *forbearance = MASForbearance.new;
    forbearance.delegate = self;
    return forbearance.horizontal;
}
- (MASForbearance *)vertical {
    MASForbearance *forbearance = MASForbearance.new;
    forbearance.delegate = self;
    return forbearance.vertical;
}


- (MASForbearance *)forbearance:(MASForbearance *)forbearance addForbearanceRule:(MASForbearanceRule)forbearanceRule {
    NSUInteger rule = self.forbearanceRules.unsignedIntegerValue;
    self.forbearanceRules = [NSNumber numberWithUnsignedInteger:rule | forbearanceRule];
    return forbearance;
}
- (MASForbearance *)forbearance:(MASForbearance *)forbearance priority:(MASLayoutPriority)priority {
    
    MAS_VIEW *view = [self performSelector:@selector(view)];
    
    NSUInteger rule = self.forbearanceRules.unsignedIntegerValue;
    
    if (!(rule & MASForbearanceRuleHugging || rule & MASForbearanceRuleCompression)) {
        NSLog(@"You must specify a rule of hugging or compression");
        return forbearance;
    }
    
    // for make.hugging.priority()
    if (rule & MASForbearanceRuleHugging && !(rule & MASForbearanceRuleHorizontal || rule & MASForbearanceRuleVertical)) {
        [view setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisHorizontal];
        [view setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisVertical];
        self.forbearanceRules = [NSNumber numberWithUnsignedInteger:0];
        return forbearance;
    }
    
    // for make.compression.priority()
    if (rule & MASForbearanceRuleCompression && !(rule & MASForbearanceRuleHorizontal || rule & MASForbearanceRuleVertical)) {
        [view setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisHorizontal];
        [view setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisVertical];
        self.forbearanceRules = [NSNumber numberWithUnsignedInteger:0];
        return forbearance;
    }
    
    if (rule & MASForbearanceRuleHugging) {
        if (rule & MASForbearanceRuleHorizontal) {
            [view setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisHorizontal];
        }
        if (rule & MASForbearanceRuleVertical) {
            [view setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisVertical];
        }
    }
    
    if (rule & MASForbearanceRuleCompression) {
        if (rule & MASForbearanceRuleHorizontal) {
            [view setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisHorizontal];
        }
        if (rule & MASForbearanceRuleVertical) {
            [view setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisVertical];
        }
    }
    self.forbearanceRules = [NSNumber numberWithUnsignedInteger:0];
    return forbearance;
}

@end
