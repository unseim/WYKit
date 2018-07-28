//
//  WYAlertSheet.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYAlertSheet.h"
#define WYScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define WYScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define WYBottomSafeAreaHeight (WYScreenHeight == 812 ? 34 : 0)

@interface WYAlertSheet ()
/* 几个确认按钮数组 */
@property (nonatomic, strong, nonnull) NSMutableArray *confirmArr;
/* 存储代码块的block */
@property (nonatomic, strong, nullable) WYButtonBlock block;
/* 用来修改某一个确认按钮的颜色 */ // 默认颜色[UIColor colorWithWhite:0.2 alpha:1.0]
@property (nonatomic, strong, nullable) NSMutableDictionary *colorDict;
/* 用来修改某一个确认按钮的字体 */ // 默认字体大小为系统默认的17号字
@property (nonatomic, strong, nullable) NSMutableDictionary *fontDict;
/* 存储取消按钮的文字内容字体和颜色 */ // 默认为“取消”，字体颜色同上
@property (nonatomic, strong, nullable) NSMutableDictionary *cancleDict;
/* 毛玻璃背景 */
@property (nonatomic, strong, nullable) UIVisualEffectView *effectView NS_CLASS_AVAILABLE_IOS(8_0);
@end

@implementation WYAlertSheet

// 几个按钮中间的间隔
static const CGFloat lineHeight = 0.4;

+ (_Nonnull instancetype)alertControllerWithArray:(nonnull NSArray <NSString *> *)confirmArray {
    return [[self alloc] initWithConfirmArr:confirmArray];
}

- (_Nonnull instancetype)initWithConfirmArr:(nonnull NSArray *)confirmArr NS_CLASS_AVAILABLE_IOS(8_0) {
    if (self = [super init]) {
        // 设置本控制器为透明
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        // 将传进来数组中的非字符串剔除
        self.confirmArr = [NSMutableArray array];
        for (id element in confirmArr) {
            if ([element isKindOfClass:[NSString class]]) {
                [self.confirmArr addObject:element];
            }
        }
    }
    return self;
}

- (void)viewDidLoad NS_CLASS_AVAILABLE_IOS(8_0) {
    [super viewDidLoad];
    
    if (self.confirmArr.count == 0) {
        return;
    }
    
    // 初始化毛玻璃背景
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.effectView.frame = CGRectMake(0, WYScreenHeight, WYScreenWidth, 100);
    [self.view addSubview:self.effectView];
    
    CGFloat titleHeight = 0;
    if (self.title) {
        // 根据title计算label高度（title文字边距为上：15、下：15、左：20、右：20）
        CGFloat height = [self.title boundingRectWithSize:(CGSizeMake(WYScreenWidth - 40, MAXFLOAT)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height + 30;
        titleHeight = height + lineHeight;
        // 放title的毛玻璃背景
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0, 0, WYScreenWidth, height);
        [self.effectView.contentView addSubview:effectView];
        // 加一个button避免点击label后dismiss掉本控制器
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = effectView.bounds;
        [effectView.contentView addSubview:button];
        // 放title的label
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(20, 15, WYScreenWidth - 40, height - 30);
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.text = self.title;
        label.numberOfLines = 0;
        [button addSubview:label];
    }
    
    // 默认的确认按钮高度 5.5inch:55、 4.7inch:53、 4.0inch:50
    CGFloat rowHeight = (WYScreenWidth == 414 ? 55.0 : (WYScreenWidth == 375 ? 53.0 : 50.0));
    // 重置按钮的高度
    if (self.rowHeight > 35 && self.rowHeight < 65) {
        rowHeight = self.rowHeight;
    }
    // 计算整个毛玻璃的高度
    CGFloat totalHeight = self.confirmArr.count * rowHeight + (self.confirmArr.count - 1) * lineHeight + titleHeight + 5 + rowHeight;
    // 重新设置毛玻璃背景的frame
    self.effectView.frame = CGRectMake(0, WYScreenHeight, WYScreenWidth, totalHeight + WYBottomSafeAreaHeight);
    // 生成一个图片，作为确认按钮点击后高亮的背景图
    UIImage *highlightImage = [self createSelectionIndicatorImage:[UIColor colorWithWhite:0.5 alpha:0.2] size:CGSizeMake(WYScreenWidth, rowHeight)];
    // 循环生成确认按钮的毛玻璃背景和确认按钮
    for (int i = 0; i < self.confirmArr.count; i++) {
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0, titleHeight + (rowHeight + lineHeight) * i, WYScreenWidth, rowHeight);
        [self.effectView.contentView addSubview:effectView];
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.tag = 101010+i;
        button.frame = effectView.bounds;
        [button setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:(UIControlStateNormal)];
        [button setTitle:self.confirmArr[i] forState:(UIControlStateNormal)];
        [button setBackgroundImage:highlightImage forState:(UIControlStateHighlighted)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [effectView.contentView addSubview:button];
    }
    // 初始化取消按钮的毛玻璃背景
    UIBlurEffect *cancleEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:cancleEffect];
    effectView.frame = CGRectMake(0, totalHeight - rowHeight, WYScreenWidth, rowHeight);
    [self.effectView.contentView addSubview:effectView];
    // 初始化取消按钮
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = effectView.bounds;
    button.titleLabel.font = self.cancleDict[@"font"];
    [button setTitleColor:self.cancleDict[@"color"] forState:(UIControlStateNormal)];
    [button setTitle:self.cancleDict[@"title"] forState:(UIControlStateNormal)];
    [button setBackgroundImage:highlightImage forState:(UIControlStateHighlighted)];
    [button addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    [effectView.contentView addSubview:button];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    // 重置按钮的颜色
    for (NSString *key in self.colorDict) {
        if (key.integerValue < self.confirmArr.count) {
            UIButton *button = [self.view viewWithTag:101010 + key.integerValue];
            [button setTitleColor:self.colorDict[key] forState:(UIControlStateNormal)];
        }
    }
    // 重置按钮的字体
    for (NSString *key in self.fontDict) {
        if (key.integerValue < self.confirmArr.count) {
            UIButton *button = [self.view viewWithTag:101010 + key.integerValue];
            button.titleLabel.font = self.fontDict[key];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated NS_CLASS_AVAILABLE_IOS(8_0) {
    [super viewDidAppear:animated];
    if (self.confirmArr.count == 0) {
        return;
    }
    // 视图加载完成后动画显示view
    CGFloat height = self.effectView.frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.effectView.frame = CGRectMake(0, WYScreenHeight - height, WYScreenWidth, height);
    }];
}

/** 点击取消按钮或空白区域收回选择框 */
- (void)dismiss NS_CLASS_AVAILABLE_IOS(8_0) {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor clearColor];
        self.effectView.frame = CGRectMake(0, WYScreenHeight, WYScreenWidth, self.effectView.frame.size.height);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            if (self.block) {
                self.block(INT_MAX, YES);
            }
        }];
    }];
}

/** 确认按钮点击事件 */
- (void)buttonAction:(UIButton *)button NS_CLASS_AVAILABLE_IOS(8_0)
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor clearColor];
        self.effectView.frame = CGRectMake(0, WYScreenHeight, WYScreenWidth, self.effectView.frame.size.height);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            if (self.block) {
                self.block(button.tag - 101010, NO);
            }
        }];
    }];
}

/** 设置第index行的按钮的颜色 */
- (void)setColor:(nonnull UIColor *)color withIndex:(NSInteger)index {
    [self.colorDict setObject:color forKey:[NSNumber numberWithInteger:index]];
}
/** 设置第index行的按钮的字体 */
- (void)setFont:(nonnull UIFont *)font withIndex:(NSInteger)index {
    [self.fontDict setObject:font forKey:[NSNumber numberWithInteger:index]];
}

/** 重置取消按钮的文字内容和颜色字体 */
- (void)setCancleButtonTitle:(nonnull NSString *)title font:(nonnull UIFont *)font color:(nonnull UIColor *)color
{
    if (title) [self.cancleDict setObject:title forKey:@"title"];
    if (color) [self.cancleDict setObject:color forKey:@"color"];
    if (font) [self.cancleDict setObject:font forKey:@"font"];
}


- (void)addConfirmButtonAction:(WYButtonBlock)block {
    self.block = block;
}

- (NSMutableDictionary *)colorDict {
    if (!_colorDict) {
        _colorDict = [NSMutableDictionary dictionary];
    }
    return _colorDict;
}

- (NSMutableDictionary *)fontDict {
    if (!_fontDict) {
        _fontDict = [NSMutableDictionary dictionary];
    }
    return _fontDict;
}

- (NSMutableDictionary *)cancleDict NS_CLASS_AVAILABLE_IOS(8_0) {
    if (!_cancleDict) {
        _cancleDict = [NSMutableDictionary dictionary];
        _cancleDict[@"title"] = @"取消";
        _cancleDict[@"color"] = [UIColor colorWithWhite:0.2 alpha:1.0];
        _cancleDict[@"font"] = [UIFont systemFontOfSize:17];
    }
    return _cancleDict;
}

/** 根据颜色和尺寸生成一张纯色的图片 */
- (UIImage *)createSelectionIndicatorImage:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
