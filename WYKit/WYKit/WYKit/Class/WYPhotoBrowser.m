//
//  WYPhotoBrowser.m
//  WYKit
//
//  Created by 汪年成 on 17/2/26.
//  Copyright © 2017年 之静之初. All rights reserved.
//

#import "WYPhotoBrowser.h"

static CGRect avatarFrame;
static UIImageView *newAvatarImageView;
static CGFloat screenWidth;
static CGFloat screenHeight;
static BOOL isClick;

@interface WYPhotoBrowser ()

@end

@implementation WYPhotoBrowser

- (instancetype)init
{
    self = [super init];
    if (self) {
        isClick = NO;
    }
    return self;
}

+ (void)showImageView:(UIImageView *)vatarImageView {
    if (vatarImageView == nil) {
        NSLog(@"avatarImageView is nil");
        return;
    }
    
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIImage *avatarImage = [vatarImageView image];
    
    
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [background setBackgroundColor:[UIColor blackColor]];
    [background setAlpha:0];
    
    
    avatarFrame = [vatarImageView convertRect:vatarImageView.bounds toView:keyWindow];
    newAvatarImageView = [[UIImageView alloc] initWithFrame:avatarFrame];
    [newAvatarImageView setImage:avatarImage];
    [newAvatarImageView setUserInteractionEnabled:YES];
    [background addSubview:newAvatarImageView];
    [keyWindow addSubview:background];
    
    
    CGFloat proportion = screenWidth / avatarImage.size.width;
    CGFloat top = screenHeight / 2 - avatarImage.size.height * proportion / 2;
    CGFloat height = avatarImage.size.height * proportion;
    
    
    UITapGestureRecognizer *tapOnBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapOnImage:)];
    tapOnBackground.numberOfTapsRequired = 1;
    tapOnBackground.numberOfTouchesRequired = 1;
    [background addGestureRecognizer:tapOnBackground];
    
    UITapGestureRecognizer *tapTwoBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapTwoImage:)];
    tapTwoBackground.numberOfTapsRequired = 2;
    [tapOnBackground requireGestureRecognizerToFail:tapTwoBackground];
    [background addGestureRecognizer:tapTwoBackground];
    
    
    UIPinchGestureRecognizer *pinchOnImage = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(actionPinchOnImage:)];
    [background addGestureRecognizer:pinchOnImage];
    
    
    UIPanGestureRecognizer *panOnImage = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionPanOnImage:)];
    [background addGestureRecognizer:panOnImage];
    
    
    UILongPressGestureRecognizer *longPressOnImage = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(actionLongPressOnImage:)];
    longPressOnImage.minimumPressDuration = 0.3f;
    [newAvatarImageView addGestureRecognizer:longPressOnImage];
    
    
    [UIView animateWithDuration:0.3f
                     animations:^
     {
         [newAvatarImageView setFrame:CGRectMake(0, top, screenWidth, height)];
         [background setAlpha:1];
     }];
}

//  双击手势
+ (void)actionTapTwoImage:(UITapGestureRecognizer *)sender {
    isClick = !isClick;
    if (isClick) {
        [UIView animateWithDuration:0.3f animations:^{
            //  宽高放大比例2倍
            [newAvatarImageView setTransform:CGAffineTransformMakeScale(2, 2)];
            //  保持居中
            [newAvatarImageView setCenter:CGPointMake(screenWidth/2, screenHeight/2)];
        }];
    }
    else {
        [UIView animateWithDuration:0.3f animations:^{
            //  宽高缩小比例2倍
            [newAvatarImageView setTransform:CGAffineTransformMakeTranslation(2, 2)];
            //  保持居中
            [newAvatarImageView setCenter:CGPointMake(screenWidth/2, screenHeight/2)];
        }];
    }
}

//  单击手势
+ (void)actionTapOnImage:(UITapGestureRecognizer *)sender {
    UIView *background = [sender view];
    [UIView animateWithDuration:0.3f animations:^ {
        [newAvatarImageView setFrame:avatarFrame];
        [background setAlpha:0];
    } completion:^(BOOL finished) {
        [background removeFromSuperview];
        newAvatarImageView = nil;
    }];
}

//  捏合手势
+ (void)actionPinchOnImage:(UIPinchGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
        newAvatarImageView.transform = CGAffineTransformScale(newAvatarImageView.transform, sender.scale, sender.scale);
        if (newAvatarImageView.frame.size.width <= screenWidth ) {
            [UIView beginAnimations:nil context:nil]; // 开始动画
            [UIView setAnimationDuration:0.5f]; // 动画时长
            newAvatarImageView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0); // 固定一倍
            [UIView commitAnimations]; // 提交动画
        }
        if (newAvatarImageView.frame.size.width > 3 * screenWidth) {
            [UIView beginAnimations:nil context:nil]; // 开始动画
            [UIView setAnimationDuration:0.5f]; // 动画时长
            newAvatarImageView.transform = CGAffineTransformMake(3, 0, 0, 3, 0, 0); // 固定三倍
            [UIView commitAnimations]; // 提交动画
        }
        
        sender.scale = 1;
    }
    
}

//  拖动
+ (void)actionPanOnImage:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGesture translationInView:newAvatarImageView.superview];
        CGPoint point = [panGesture velocityInView:newAvatarImageView];
        
//        NSLog(@"point1 = %@,   point2 = %@",NSStringFromCGPoint(translation), NSStringFromCGPoint(point));
        
//        if (translation.x < 0 && translation.y < 0 && point.x > 0 && point.y > 0)
//        {
            
            [newAvatarImageView setCenter:(CGPoint){newAvatarImageView.center.x + translation.x, newAvatarImageView.center.y + translation.y}];
            
            [panGesture setTranslation:CGPointZero inView:newAvatarImageView.superview];
        
//        }
        
        
    }
}


//  长按
+ (void)actionLongPressOnImage:(UILongPressGestureRecognizer *)sender {
    if ([sender state] == UIGestureRecognizerStateEnded) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:(id<UIActionSheetDelegate>)self                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"保存图片", nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:[sender view]];
    }
}


+ (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(newAvatarImageView.image, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), NULL);
    }
}


+ (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        
//        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil
//                                                             message:@"保存失败"
//                                                            delegate:nil
//                                                   cancelButtonTitle:@"确定"
//                                                   otherButtonTitles:nil, nil];
//        [errorAlert show];
        
        [WYHiddenAlertView showMessage3:@"保存失败" time:3.0];
        
    } else {
        
//        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil
//                                                             message:@"保存成功"
//                                                            delegate:nil
//                                                   cancelButtonTitle:@"确定"
//                                                   otherButtonTitles:nil, nil];
//        [errorAlert show];
        
        [WYHiddenAlertView showMessage3:@"保存成功" time:3.0];
    }
}




@end
