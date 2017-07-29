//
//  WYAlertSheet.m
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYAlertSheet.h"

@interface WYAlertSheet ()
{
    CGSize size;
}
@property (nonatomic, strong) UIView *bgkView;
@end

@implementation WYAlertSheet

//  初始化
- (instancetype)initWithtitleArr:(NSArray *)titleArr
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        size = [UIScreen mainScreen].bounds.size;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSheet)];
        [self addGestureRecognizer:tap];
        [self makeBaseUIWithTitleArr:titleArr];
    }
    return self;
}


- (void)makeBaseUIWithTitleArr:(NSArray *)titleArr
{
    self.bgkView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height, size.width, titleArr.count * 44 + 49)];
    _bgkView.backgroundColor = [UIColor colorWithRed:0xe9/255.0 green:0xe9/255.0 blue:0xe9/255.0 alpha:1.0];
    [self addSubview:_bgkView];
    
    CGFloat y = [self createBtnWithTitle:@"取消" origin_y: _bgkView.frame.size.height - 44 tag:-1 action:@selector(hiddenSheet)] - 49;
    for (int i = 0; i < titleArr.count; i++) {
        y = [self createBtnWithTitle:titleArr[i] origin_y:y tag:i action:@selector(click:)];
    }
}



- (void)show
{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.2]];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = _bgkView.frame;
        frame.origin.y -= frame.size.height;
        _bgkView.frame = frame;
    }];
}


- (CGFloat)createBtnWithTitle:(NSString *)title
                     origin_y:(CGFloat)y
                          tag:(NSInteger)tag
                       action:(SEL)method
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, y, size.width, 44);
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = tag;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:method forControlEvents:UIControlEventTouchUpInside];
    [_bgkView addSubview:btn];
    return y -= tag == -1 ? 0 : 44.5;
}


- (void)hiddenSheet
{
    [UIView animateWithDuration:0.20 animations:^{
        CGRect frame = _bgkView.frame;
        frame.origin.y += frame.size.height;
        _bgkView.frame = frame;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}


- (void)click:(UIButton *)btn
{
    !_clickAlertSheet ?: _clickAlertSheet(btn.tag);
    [self hiddenSheet];
}



@end
