//
//  HomeViewController.m
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "HomeViewController.h"
@interface HomeViewController ()

@end
@implementation HomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功能测试";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *bu = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [bu setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:bu];
    [bu addTarget:self action:@selector(Mothed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self backButtonTouched:^(UIViewController *vc) {
        NSLog(@"不返回");
    }];
    
    
}


- (void)Mothed:(UIButton *)button
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
