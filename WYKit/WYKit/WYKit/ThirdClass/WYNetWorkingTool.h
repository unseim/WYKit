//
//  WYNetWorkingTool.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>
#import "AFNetworkActivityIndicatorManager.h"

/** 是否开启https SSL 验证 */
#define openHttpsSSL NO

/** SSL 证书名称，仅支持cer格式。“app.bishe.com.cer”,则填“app.bishe.com” */
#define certificate @"xiaokaapi.com"

#define WYWeak  __weak __typeof(self) weakSelf = self

//请求成功的回调block
typedef void(^responseSuccess)(NSURLSessionDataTask *task, id  responseObject);

//请求失败的回调block
typedef void(^responseFailed)(NSURLSessionDataTask *task, NSError *error,id responseObject);

//文件下载的成功回调block
typedef void(^downloadSuccess)(NSURLResponse *response, NSURL *filePath);

//文件下载的失败回调block
typedef void(^downloadFailed)( NSError *error);

//文件上传下载的进度block
typedef void (^progress)(NSProgress *progress);


//  网络状态
typedef NS_ENUM(NSUInteger, WYNetWorkingState)
{
    WYNetWorkingHave,           //  有网络
    WYNetWorkingNotReachable    //  没有网络
};

//  请求体和返回体格式
typedef NS_ENUM(NSUInteger, RequestManagerType)
{
    JSONRequestManager,     //  JSON请求
    HTTPRequestManager      //  HTTP请求
};

//  网络监测回调block
typedef void(^WYNetWorkingStateBlock)(WYNetWorkingState netState);

@interface WYNetWorkingTool : AFHTTPSessionManager <NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

/** 已经下载的数据 */
@property (nonatomic, strong) NSData *resumeData;

/** 续传文件沙盒存储路径 */
@property (nonatomic, copy) NSString *resumeDataPath;

/** 自定义session,设置代理 */
@property (nonatomic, strong) NSURLSession *downloadSession;

/** 取消所有的网络请求 */
+ (void)cancelAllNetWorking;

/** 网络监测 */
+ (void)netWorkState:(WYNetWorkingStateBlock)block;


/**
 get请求
 @param request 请求体类型
 @param url 请求url
 @param params 参数
 @param isReadCache 是否读取缓存
 @param success 成功回调
 @param failed 失败回调
 */
+ (void)getWithRuquest:(RequestManagerType)request
                   Url:(NSString *)url
                params:(NSDictionary *)params
           isReadCache:(BOOL)isReadCache
               success:(responseSuccess)success
                failed:(responseFailed)failed;


/**
 post请求
 
 @param url 请求url
 @param params 参数
 @param isReadCache 是否读取缓存
 @param success 成功回调
 @param failed 失败回调
 */
+ (void)postWithRuquest:(RequestManagerType)request
                    Url:(NSString *)url
                 params:(NSDictionary *)params
            isReadCache:(BOOL)isReadCache
                success:(responseSuccess)success
                 failed:(responseFailed)failed;



/**
 put请求
 
 @param url 请求url
 @param params 参数
 @param isReadCache 是否读取缓存
 @param success 成功回调
 @param failed 失败回调
 */
+ (void)putWithRuquest:(RequestManagerType)request
                   Url:(NSString *)url
                params:(NSDictionary *)params
           isReadCache:(BOOL)isReadCache
               success:(responseSuccess)success
                failed:(responseFailed)failed;


/**
 delete请求
 
 @param url 请求url
 @param params 参数
 @param isReadCache 是否读取缓存
 @param success 成功回调
 @param failed 失败回调
 */
+ (void)deleteWithRuquest:(RequestManagerType)request
                      Url:(NSString *)url
                   params:(NSDictionary *)params
              isReadCache:(BOOL)isReadCache
                  success:(responseSuccess)success
                   failed:(responseFailed)failed;



/**
 文件上传(图片上传)
 
 @param url 请求url
 @param params 请求参数
 @param fileData 上传文件的二进制数据
 @param name 制定参数名
 @param fileName 文件名(加后缀名)
 @param mimeType 文件类型
 @param progress 上传进度
 @param success 成功回调
 @param failed 失败回调
 */
+ (void)uploadWithRuquest:(RequestManagerType)request
                      Url:(NSString *)url
                   params:(NSDictionary *)params
                 fileData:(NSData *)fileData
                     name:(NSString *)name
                 fileName:(NSString *)fileName
                 mimeType:(NSString *)mimeType
                 progress:(progress)progress
                  success:(responseSuccess)success
                   failed:(responseFailed)failed;


/**
 上传图片(多图)
 
 @param params       上传图片预留参数---视具体情况而定 可移除
 @param imageArray   上传的图片数组
 @param fileName     上传的图片数组fileName
 @param url          上传的url
 @param success      上传成功的回调
 @param failed       上传失败的回调
 @param progress     上传进度
 */
+ (void)uploadImageWithRuquest:(RequestManagerType)request
                           Url:(NSString *)url
                        params:(NSDictionary *)params
                    imageArray:(NSArray *)imageArray
                      fileName:(NSString *)fileName
                      progress:(progress)progress
                       success:(responseSuccess)success
                        failed:(responseFailed)failed;


/**
 视频上传
 
 @param operations   上传视频预留参数---视具体情况而定 可移除
 @param videoPath    上传视频的本地沙河路径
 @param url          上传的url
 @param success      成功的回调
 @param failed       失败的回调
 @param progress     上传的进度
 */
+ (void)uploadVideoWithRuquest:(RequestManagerType)request
                           Url:(NSString *)url
                        params:(NSDictionary *)params
                     videoPath:(NSString *)videoPath
                      progress:(progress)progress
                       success:(responseSuccess)success
                        failed:(responseFailed)failed;


/** 文件下载 */
+ (void)downloadWithUrl:(NSString *)url;


/** 暂停下载 */
- (void)pauseDownload;


/**
 继续下载(断点下载)
 
 @param progress 下载进度
 @param success 成功回调
 @param failed 失败回调
 */
- (void)resumeDownloadprogress:(progress)progress
                       success:(downloadSuccess)success
                        failed:(downloadFailed)failed ;



@end
