//
//  UIButton+WYCountdown.m
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UIButton+WYDrag.h"
#import <objc/runtime.h>
#define PADDING     self.frame.size.width/2

static void *DragEnableKey = &DragEnableKey;
static void *AdsorbEnableKey = &AdsorbEnableKey;

@implementation UIButton (WYDrag)

- (void)setDragEnable:(BOOL)dragEnable
{
    objc_setAssociatedObject(self, DragEnableKey, @(dragEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isDragEnable
{
    return [objc_getAssociatedObject(self, DragEnableKey) boolValue];
}

- (void)setAdsorbEnable:(BOOL)adsorbEnable
{
    objc_setAssociatedObject(self, AdsorbEnableKey, @(adsorbEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isAdsorbEnable
{
    return [objc_getAssociatedObject(self, AdsorbEnableKey) boolValue];
}

CGPoint beginPoint;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = YES;
    if (![objc_getAssociatedObject(self, DragEnableKey) boolValue]) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    beginPoint = [touch locationInView:self];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
    if (![objc_getAssociatedObject(self, DragEnableKey) boolValue]) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.highlighted) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
        self.highlighted = NO;
    }
    
    if (self.superview && [objc_getAssociatedObject(self,AdsorbEnableKey) boolValue] ) {
        float marginLeft = self.frame.origin.x;
        float marginRight = self.superview.frame.size.width - self.frame.origin.x - self.frame.size.width;
        float marginTop = self.frame.origin.y;
        float marginBottom = self.superview.frame.size.height - self.frame.origin.y - self.frame.size.height;
        [UIView animateWithDuration:0.125 animations:^(void){
            if (marginTop < 60) {
                self.frame = CGRectMake(marginLeft < marginRight ? marginLeft < PADDING ? PADDING : self.frame.origin.x : marginRight < PADDING ? self.superview.frame.size.width - self.frame.size.width - PADDING:self.frame.origin.x, PADDING, self.frame.size.width, self.frame.size.height);
            }
            else if (marginBottom < 60) {
                self.frame = CGRectMake(marginLeft < marginRight?marginLeft < PADDING?PADDING : self.frame.origin.x:marginRight < PADDING?self.superview.frame.size.width - self.frame.size.width - PADDING : self.frame.origin.x, self.superview.frame.size.height - self.frame.size.height - PADDING, self.frame.size.width, self.frame.size.height);
                
            }
            else {
                self.frame = CGRectMake(marginLeft < marginRight ? PADDING : self.superview.frame.size.width - self.frame.size.width - PADDING, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
            }
        }];
        
    }
}


@end
