//
//  WYNetWorkingTool.m
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

/*! 相册 */
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
/*! 视频 */
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>
#import <AVFoundation/AVMediaFormat.h>

#import "WYNetWorkingTool.h"
#import "WYCache.h"
#import "UIImage+CompressImage.h"


static WYNetWorkingTool *instance;
@implementation WYNetWorkingTool

#pragma mark - https验证
+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:certificate ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    securityPolicy.pinnedCertificates = [NSSet setWithArray:@[certData]];
    
    return securityPolicy;
}


#pragma mark - 取消所有的网络请求
+ (void)cancelAllNetWorking
{
    
    [instance.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //    [[WYNetWorkingTool sharedJSONManager].tasks makeObjectsPerformSelector:@selector(cancel)];
    //    [[WYNetWorkingTool sharedHTTPManager].tasks makeObjectsPerformSelector:@selector(cancel)];
}


#pragma mark - JSON请求单例
+ (instancetype)sharedJSONManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [WYNetWorkingTool manager];
        //  请求超时时间
        instance.requestSerializer.timeoutInterval = 10;
        //  打开状态栏等待菊花
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        //  返回类型
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
        //  设置请求体和返回内容
        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
        
        //  https ssl 验证。
        if(openHttpsSSL)
        {
            [self customSecurityPolicy];
        }
    });
    return instance;
}

#pragma mark - HTTP请求单列
+ (instancetype)sharedHTTPManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [WYNetWorkingTool manager];
        //  请求超时时间
        instance.requestSerializer.timeoutInterval = 10;
        //  打开状态栏等待菊花
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        //  返回类型
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
        //  设置请求体和返回内容
        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
        instance.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        //  https ssl 验证。
        if(openHttpsSSL)
        {
            [self customSecurityPolicy];
        }
    });
    return instance;
}


- (NSURLSession *)downloadSession
{
    if (_downloadSession == nil) {
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        // nil : nil的效果跟 [[NSOperationQueue alloc] init] 是一样的
        _downloadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    
    return _downloadSession;
}


#pragma mark - get请求
+ (void)getWithRuquest:(RequestManagerType)request
                   Url:(NSString *)url
                params:(NSDictionary *)params
           isReadCache:(BOOL)isReadCache
               success:(responseSuccess)success
                failed:(responseFailed)failed
{
    if (url == nil)
    {
        return;
    }
    
    if (request == 0) {
        instance = [WYNetWorkingTool sharedJSONManager];
    }
    else {
        instance = [WYNetWorkingTool sharedHTTPManager];
    }
    
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
    [instance GET:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         //请求成功的回调
         if (success) {
             success(task,responseObject);
         }
         //请求成功,保存数据
         [WYCache saveDataCache:responseObject forKey:url];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //请求失败的回调
         id cacheData= nil;
         //是否读取缓存
         if (isReadCache) {
             cacheData = [WYCache readCache:url];
         }else {
             cacheData = nil;
         }
         
         if (failed) {
             failed(task,error,cacheData);
         }
         
     }];
}


#pragma mark - post请求
+ (void)postWithRuquest:(RequestManagerType)request
                    Url:(NSString *)url
                 params:(NSDictionary *)params
            isReadCache:(BOOL)isReadCache
                success:(responseSuccess)success
                 failed:(responseFailed)failed
{
    if (url == nil)
    {
        return;
    }
    
    if (request == 0) {
        instance = [WYNetWorkingTool sharedJSONManager];
    }
    else {
        instance = [WYNetWorkingTool sharedHTTPManager];
    }
    
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
    [instance POST:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (success) {
             success(task,responseObject);
         }
         //请求成功,保存数据
         [WYCache saveDataCache:responseObject forKey:url];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         id cacheData= nil;
         //是否读取缓存
         if (isReadCache) {
             cacheData = [WYCache readCache:url];
         }else {
             cacheData = nil;
         }
         
         if (failed) {
             failed(task,error,cacheData);
         }
     }];
}



#pragma mark - put请求
+ (void)putWithRuquest:(RequestManagerType)request
                   Url:(NSString *)url
                params:(NSDictionary *)params
           isReadCache:(BOOL)isReadCache
               success:(responseSuccess)success
                failed:(responseFailed)failed
{
    if (url == nil)
    {
        return;
    }
    
    if (request == 0) {
        instance = [WYNetWorkingTool sharedJSONManager];
    }
    else {
        instance = [WYNetWorkingTool sharedHTTPManager];
    }
    
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
    
    [instance PUT:URLString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功的回调
        if (success) {
            success(task,responseObject);
        }
        //请求成功,保存数据
        [WYCache saveDataCache:responseObject forKey:url];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        id cacheData= nil;
        //是否读取缓存
        if (isReadCache) {
            cacheData = [WYCache readCache:url];
        }else {
            cacheData = nil;
        }
        
        if (failed) {
            failed(task,error,cacheData);
        }
    }];
}


#pragma mark - delete请求
+ (void)deleteWithRuquest:(RequestManagerType)request
                      Url:(NSString *)url
                   params:(NSDictionary *)params
              isReadCache:(BOOL)isReadCache
                  success:(responseSuccess)success
                   failed:(responseFailed)failed
{
    if (url == nil)
    {
        return;
    }
    
    if (request == 0) {
        instance = [WYNetWorkingTool sharedJSONManager];
    }
    else {
        instance = [WYNetWorkingTool sharedHTTPManager];
    }
    
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
    
    [instance DELETE:URLString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功的回调
        if (success) {
            success(task,responseObject);
        }
        //请求成功,保存数据
        [WYCache saveDataCache:responseObject forKey:url];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        id cacheData= nil;
        //是否读取缓存
        if (isReadCache) {
            cacheData = [WYCache readCache:url];
        }else {
            cacheData = nil;
        }
        
        if (failed) {
            failed(task,error,cacheData);
        }
    }];
}


#pragma mark - 文件上传
+ (void)uploadWithRuquest:(RequestManagerType)request
                      Url:(NSString *)url
                   params:(NSDictionary *)params
                 fileData:(NSData *)fileData
                     name:(NSString *)name
                 fileName:(NSString *)fileName
                 mimeType:(NSString *)mimeType
                 progress:(progress)progress
                  success:(responseSuccess)success
                   failed:(responseFailed)failed
{
    if (url == nil)
    {
        return;
    }
    
    if (request == 0) {
        instance = [WYNetWorkingTool sharedJSONManager];
    }
    else {
        instance = [WYNetWorkingTool sharedHTTPManager];
    }
    
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
    
    [instance POST:URLString
        parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
     } progress:^(NSProgress * _Nonnull uploadProgress) {
         if (progress) {
             progress(uploadProgress);
         }
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         if (success) {
             success(task,responseObject);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failed) {
             failed(task,error,nil);
         }
         
     }];
}


#pragma mark - 多图上传
+ (void)uploadImageWithRuquest:(RequestManagerType)request
                           Url:(NSString *)url
                        params:(NSDictionary *)params
                    imageArray:(NSArray *)imageArray
                      fileName:(NSString *)fileName
                      progress:(progress)progress
                       success:(responseSuccess)success
                        failed:(responseFailed)failed
{
    if (url == nil)
    {
        return;
    }
    
    if (request == 0) {
        instance = [WYNetWorkingTool sharedJSONManager];
    }
    else {
        instance = [WYNetWorkingTool sharedHTTPManager];
    }
    
    WYWeak;
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
    
    [instance POST:URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /*! 出于性能考虑,将上传图片进行压缩 */
        [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            /*! image的压缩方法 */
            UIImage *resizedImage;
            /*! 此处是使用原生系统相册 */
            if([obj isKindOfClass:[ALAsset class]])
            {
                // 用ALAsset获取Asset URL  转化为image
                ALAssetRepresentation *assetRep = [obj defaultRepresentation];
                
                CGImageRef imgRef = [assetRep fullResolutionImage];
                resizedImage = [UIImage imageWithCGImage:imgRef
                                                   scale:1.0
                                             orientation:(UIImageOrientation)assetRep.orientation];
                resizedImage = [weakSelf imageWithImage:resizedImage scaledToSize:resizedImage.size];
            }
            else
            {
                /*! 此处是使用其他第三方相册，可以自由定制压缩方法 */
                resizedImage = obj;
            }
            
            /*! 此处压缩方法是jpeg格式是原图大小的0.8倍，要调整大小的话，就在这里调整就行了还是原图等比压缩 */
            NSData *imgData = nil;
            if (UIImagePNGRepresentation(resizedImage) == nil) {
                imgData = UIImageJPEGRepresentation(resizedImage, 0.8);
            }
            else {
                imgData = UIImagePNGRepresentation(resizedImage);
            }
            
            if (imgData != nil)     // 图片数据不为空才传递 fileName
            {
                [formData appendPartWithFileData:imgData
                                            name:[NSString stringWithFormat:@"picflie%ld",(long)idx]
                                        fileName:fileName
                                        mimeType:@"image/jpeg"];
            }
        }];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failed) {
            failed(task,error,nil);
        }
    }];
    
}


#pragma mark - 视频上传
+ (void)uploadVideoWithRuquest:(RequestManagerType)request
                           Url:(NSString *)url
                        params:(NSDictionary *)params
                     videoPath:(NSString *)videoPath
                      progress:(progress)progress
                       success:(responseSuccess)success
                        failed:(responseFailed)failed
{
    if (request == 0) {
        instance = [WYNetWorkingTool sharedJSONManager];
    }
    else {
        instance = [WYNetWorkingTool sharedHTTPManager];
    }
    
    /*! 获得视频资源 */
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:videoPath]  options:nil];
    
    /*! 压缩 */
    
    //    NSString *const AVAssetExportPreset640x480;
    //    NSString *const AVAssetExportPreset960x540;
    //    NSString *const AVAssetExportPreset1280x720;
    //    NSString *const AVAssetExportPreset1920x1080;
    //    NSString *const AVAssetExportPreset3840x2160;
    
    /*! 创建日期格式化器 */
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    
    /*! 转化后直接写入Library---caches */
    NSString *videoWritePath = [NSString stringWithFormat:@"output-%@.mp4",[formatter stringFromDate:[NSDate date]]];
    NSString *outfilePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", videoWritePath];
    
    AVAssetExportSession *avAssetExport = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    
    avAssetExport.outputURL = [NSURL fileURLWithPath:outfilePath];
    avAssetExport.outputFileType =  AVFileTypeMPEG4;
    
    [avAssetExport exportAsynchronouslyWithCompletionHandler:^{
        switch ([avAssetExport status]) {
            case AVAssetExportSessionStatusCompleted:
            {
                [instance POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    NSURL *filePathURL2 = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", outfilePath]];
                    // 获得沙盒中的视频内容
                    [formData appendPartWithFileURL:filePathURL2 name:@"video" fileName:outfilePath mimeType:@"application/octet-stream" error:nil];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    if (progress) {
                        progress(uploadProgress);
                    }
                } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
                    if (success) {
                        success(task,responseObject);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (failed) {
                        failed(task,error,nil);
                    }
                }];
                break;
            }
            default:
                break;
        }
    }];
}


#pragma mark - 文件下载 支持断点下载
+ (void)downloadWithUrl:(NSString *)url
{
    
    // 1. URL
    NSURL *URL = [NSURL URLWithString:url];
    
    // 2. 发起下载任务
    [WYNetWorkingTool sharedJSONManager].downloadTask = [[WYNetWorkingTool sharedJSONManager].downloadSession downloadTaskWithURL:URL];
    
    // 3. 启动下载任务
    [[WYNetWorkingTool sharedJSONManager].downloadTask resume];
    
}


#pragma mark - 暂停下载
- (void)pauseDownload
{
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData)
     {
         self.resumeData = resumeData;
         //将已经下载的数据存到沙盒,下次APP重启后也可以继续下载
         NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
         // 拼接文件路径   上面获取的文件路径加上文件名
         NSString *path = [@"sssssaad" stringByAppendingString:@".plist"];
         NSString *plistPath = [doc stringByAppendingPathComponent:path];
         self.resumeDataPath = plistPath;
         [resumeData writeToFile:plistPath atomically:YES];
         self.resumeData = resumeData;
         self.downloadTask = nil;
     }];
}


#pragma mark - 继续下载
- (void)resumeDownloadprogress:(progress)progress
                       success:(downloadSuccess)success
                        failed:(downloadFailed)failed
{
    if (self.resumeData == nil)
    {
        NSData *resume_data = [NSData dataWithContentsOfFile:self.resumeDataPath];
        if (resume_data == nil) {
            // 即没有内存续传数据,也没有沙盒续传数据,就续传了
            return;
        } else {
            // 当沙盒有续传数据时,在内存中保存一份
            self.resumeData = resume_data;
        }
    }
    
    // 续传数据时,依然不能使用回调
    // 续传数据时起始新发起了一个下载任务,因为cancel方法是把之前的下载任务干掉了 (类似于NSURLConnection的cancel)
    // resumeData : 当新建续传数据时,resumeData不能为空,一旦为空,就崩溃
    // downloadTaskWithResumeData :已经把Range封装进去了
    
    if (self.resumeData != nil) {
        self.downloadTask = [self.downloadSession downloadTaskWithResumeData:self.resumeData];
        // 重新发起续传任务时,也要手动的启动任务
        [self.downloadTask resume];
    }
}


#pragma NSURLSessionDownloadDelegate
//  监听文件下载进度的代理方法
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    // 计算进度
    float downloadProgress = (float)totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"%f",downloadProgress);
    
}

//  文件下载结束时的代理方法 (必须实现的)
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    // location : 文件下载结束之后的缓存路径
    // 使用session实现文件下载时,文件下载结束之后,默认会删除,所以文件下载结束之后,需要我们手动的保存一份
    NSLog(@"%@",location.path);
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    // NSString *path = @"/Users/allenjzl/Desktop/ssssss/zzzz.zip";
    // 文件下载结束之后,需要立即把文件拷贝到一个不会销毁的地方
    
    [[NSFileManager defaultManager] copyItemAtPath:location.path toPath:[path stringByAppendingString:@"/.zzzzzzz.zip"] error:NULL];
    NSLog(@"%@",path);
}


#pragma mark----网络检测
+ (void)netWorkState:(WYNetWorkingStateBlock)block;
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    // 提示：要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager startMonitoring];
    //检测的结果
    //    __block typeof(self) bself = self;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == 0 || status == -1) {
            //弹出提示框
            //            [bself showWarningView];
            
            block(WYNetWorkingNotReachable);    // 没有网络
        }
        else{
            
            block(WYNetWorkingHave);    //  移动数据 或者 WIFI 网络
        }
    }];
}


#pragma mark---网络断开时弹出提示框
+ (void)showWarningView
{
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:@"网络断开，请检查网络设置"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"去设置", nil];
    [alter show];
}

+ (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}


#pragma mark - url 中文格式化
+ (NSString *)strUTF8Encoding:(NSString *)str
{
    /*! ios9适配的话 打开第一个 */
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 9.0)
    {
        return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    }
    else
    {
        return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}


#pragma mark - 压缩图片尺寸
/*! 对图片尺寸进行压缩 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    if (newSize.height > 375 / newSize.width * newSize.height)
    {
        newSize.height = 375 / newSize.width * newSize.height;
    }
    
    if (newSize.width > 375)
    {
        newSize.width = 375;
    }
    
    UIImage *newImage = [UIImage needCenterImage:image size:newSize scale:1.0];
    return newImage;
}

@end
