//
//  UIViewController+ImagePickerManager.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UIViewController+ImagePickerManager.h"
#import "objc/runtime.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

#ifdef DEBUG
#define debugLog(...)    NSLog(__VA_ARGS__)
#else
#define debugLog(...)
#endif

#define WY_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define WY_IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

static  BOOL canEdit = NO;
static  BOOL tempCanEdit = NO;
static  char blockKey;
static  char tempBlockKey;

@interface UIViewController() <UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate>
@property (nonatomic,copy)photoBlock photoBlock;
@property (nonatomic,copy)photoBlock tempPhotoBlock;
@end

@implementation UIViewController (ImagePickerManager)

#pragma mark-set
- (void)setPhotoBlock:(photoBlock)photoBlock
{
    objc_setAssociatedObject(self, &blockKey, photoBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTempPhotoBlock:(photoBlock)tempPhotoBlock
{
    objc_setAssociatedObject(self, &tempBlockKey, tempPhotoBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark-get
- (photoBlock )photoBlock
{
    return objc_getAssociatedObject(self, &blockKey);
}

- (photoBlock)tempPhotoBlock
{
    return objc_getAssociatedObject(self, &tempBlockKey);
}

- (void)showCanEdit:(BOOL)edit photo:(photoBlock)block
{
    tempCanEdit = edit;
    self.tempPhotoBlock = [block copy];
    UIActionSheet *sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册中获取", nil];
    sheet.tag = 2599;
    [sheet showInView:self.view];
}

- (void)showPhotoLibraryCanEdit:(BOOL)edit photo:(photoBlock)block
{
    canEdit = edit;
    self.photoBlock = [block copy];
    
    //权限
    if(![self authorWithType:1]) return;
    
    //相册
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = canEdit;
    imagePickerController.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)showCameraCanEdit:(BOOL)edit photo:(photoBlock)block
{
    canEdit = edit;
    self.photoBlock = [block copy];
    
    //权限
    if(![self authorWithType:0]) return;
    
    //相机
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = canEdit;
    //是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:NULL];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该设备不支持相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

/**
 权限是否开启
 @param type 0相机,1相册
 @return 权限开启YES,否则NO
 */
- (BOOL)authorWithType:(NSInteger)type
{
    //权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
        NSString *photoType = type==0?@"相机":@"相册";
        NSString * title = [NSString stringWithFormat:@"%@权限未开启",photoType];
        NSString * msg = [NSString stringWithFormat:@"请在系统设置中开启该应用%@服务\n(设置->隐私->%@->开启)",photoType,photoType];
        NSString * cancelTitle = @"知道了";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil, nil];
        [alertView show];
        debugLog(@"%@权限未开启",photoType);
        return NO;
    }
    return YES;
}

#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(WY_IS_IPHONE) [self handelClickWithActionSheet:actionSheet buttonIndex:buttonIndex];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(WY_IS_PAD) [self handelClickWithActionSheet:actionSheet buttonIndex:buttonIndex];
}

#pragma mark - Action
- (void)handelClickWithActionSheet:(UIActionSheet *)actionSheet buttonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==2599)
    {
        switch (buttonIndex)
        {
            case 0://相机
            {
                [self showCameraCanEdit:tempCanEdit photo:self.tempPhotoBlock];
            }
                break;
            case 1://相册
            {
                [self showPhotoLibraryCanEdit:tempCanEdit photo:self.tempPhotoBlock];
            }
                break;
            default:
                break;
        }
    }
}


#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image;
    //是否要裁剪
    if ([picker allowsEditing]){
        
        //编辑之后的图像
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        
    } else {
        
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if(self.photoBlock)
    {
        self.photoBlock(image);
    }
}


@end

