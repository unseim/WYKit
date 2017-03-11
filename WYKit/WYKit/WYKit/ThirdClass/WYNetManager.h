//
//  WYNetManager.h
//  WYKit
//
//  Created by 汪年成 on 16/12/23.
//  Copyright © 2016年 之静之初. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define WYNetManagerShare [WYNetManager sharedWYNetManager]

#define WYWeak  __weak __typeof(self) weakSelf = self

/*! 过期属性或方法名提醒 */
#define WYNetManagerDeprecated(instead) __deprecated_msg(instead)

/*! 判断是否有网 */
#ifndef kIsHaveNetwork
#define kIsHaveNetwork   [WYNetManager WY_isHaveNetwork]
#endif

/*! 判断是否为手机网络 */
#ifndef kIs3GOr4GNetwork
#define kIs3GOr4GNetwork [WYNetManager WY_is3GOr4GNetwork]
#endif

/*! 判断是否为WiFi网络 */
#ifndef kIsWiFiNetwork
#define kIsWiFiNetwork   [WYNetManager WY_isWiFiNetwork]
#endif


/*! 使用枚举NS_ENUM:区别可判断编译器是否支持新式枚举,支持就使用新的,否则使用旧的 */
typedef NS_ENUM(NSUInteger, WYNetworkStatus)
{
    /*! 未知网络 */
    WYNetworkStatusUnknown           = 0,
    /*! 没有网络 */
    WYNetworkStatusNotReachable,
    /*! 手机 3G/4G 网络 */
    WYNetworkStatusReachableViaWWAN,
    /*! wifi 网络 */
    WYNetworkStatusReachableViaWiFi
};

/*！定义请求类型的枚举 */
typedef NS_ENUM(NSUInteger, WYHttpRequestType)
{
    /*! get请求 */
    WYHttpRequestTypeGet = 0,
    /*! post请求 */
    WYHttpRequestTypePost,
    /*! put请求 */
    WYHttpRequestTypePut,
    /*! delete请求 */
    WYHttpRequestTypeDelete
};

/*! 实时监测网络状态的 block */
typedef void(^WYNetworkStatusBlock)(WYNetworkStatus status);

/*! 定义请求成功的 block */
typedef void( ^ WYResponseSuccess)(id response);

/*! 定义请求失败的 block */
typedef void( ^ WYResponseFail)(NSError *error);

/*! 定义上传进度 block */
typedef void( ^ WYUploadProgress)(int64_t bytesProgress,
                                  int64_t totalBytesProgress);
/*! 定义下载进度 block */
typedef void( ^ WYDownloadProgress)(int64_t bytesProgress,
                                    int64_t totalBytesProgress);

/*!
 *  方便管理请求任务。执行取消，暂停，继续等任务.
 *  - (void)cancel，取消任务
 *  - (void)suspend，暂停任务
 *  - (void)resume，继续任务
 */
typedef NSURLSessionTask WYURLSessionTask;


@interface WYNetManager : NSObject


/*! 获取当前网络状态 */
@property (nonatomic, assign) WYNetworkStatus netWorkStatu;

/*!
 *  获得全局唯一的网络请求实例单例方法
 *
 *  @return 网络请求类WYNetManager单例
 */
+ (WYNetManager *)sharedWYNetManager;

#pragma mark - 网络请求的类方法 --- get / post / put / delete
/*!
 *  网络请求方法,block回调
 *
 *  @param type         get / post
 *  @param urlString    请求的地址
 *  @param paraments    请求的参数
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 *  @param progress 进度
 */
+ (WYURLSessionTask *)WY_requestWithType:(WYHttpRequestType)type
                               urlString:(NSString *)urlString
                              parameters:(NSDictionary *)parameters
                            successBlock:(WYResponseSuccess)successBlock
                            failureBlock:(WYResponseFail)failureBlock
                                progress:(WYDownloadProgress)progress;

/*!
 *  上传图片(多图)
 *
 *  @param parameters   上传图片预留参数---视具体情况而定 可移除
 *  @param imageArray   上传的图片数组
 *  @param fileName     上传的图片数组fileName
 *  @param urlString    上传的url
 *  @param successBlock 上传成功的回调
 *  @param failureBlock 上传失败的回调
 *  @param progress     上传进度
 */
+ (WYURLSessionTask *)WY_uploadImageWithUrlString:(NSString *)urlString
                                       parameters:(NSDictionary *)parameters
                                       imageArray:(NSArray *)imageArray
                                         fileName:(NSString *)fileName
                                     successBlock:(WYResponseSuccess)successBlock
                                      failurBlock:(WYResponseFail)failureBlock
                                   upLoadProgress:(WYUploadProgress)progress;

/*!
 *  视频上传
 *
 *  @param operations   上传视频预留参数---视具体情况而定 可移除
 *  @param videoPath    上传视频的本地沙河路径
 *  @param urlString     上传的url
 *  @param successBlock 成功的回调
 *  @param failureBlock 失败的回调
 *  @param progress     上传的进度
 */
+ (void)WY_uploadVideoWithUrlString:(NSString *)urlString
                         parameters:(NSDictionary *)parameters
                          videoPath:(NSString *)videoPath
                       successBlock:(WYResponseSuccess)successBlock
                       failureBlock:(WYResponseFail)failureBlock
                     uploadProgress:(WYUploadProgress)progress;

/*!
 *  文件下载
 *
 *  @param operations   文件下载预留参数---视具体情况而定 可移除
 *  @param savePath     下载文件保存路径
 *  @param urlString        请求的url
 *  @param successBlock 下载文件成功的回调
 *  @param failureBlock 下载文件失败的回调
 *  @param progress     下载文件的进度显示
 */
+ (WYURLSessionTask *)WY_downLoadFileWithUrlString:(NSString *)urlString
                                        parameters:(NSDictionary *)parameters
                                          savaPath:(NSString *)savePath
                                      successBlock:(WYResponseSuccess)successBlock
                                      failureBlock:(WYResponseFail)failureBlock
                                  downLoadProgress:(WYDownloadProgress)progress;

#pragma mark - 网络状态监测
/*!
 *  开启实时网络状态监测，通过Block回调实时获取(此方法可多次调用)
 */
+ (void)WY_startNetWorkMonitoringWithBlock:(WYNetworkStatusBlock)networkStatus;

/*!
 *  是否有网
 *
 *  @return YES, 反之:NO
 */
+ (BOOL)WY_isHaveNetwork;

/*!
 *  是否是手机网络
 *
 *  @return YES, 反之:NO
 */
+ (BOOL)WY_is3GOr4GNetwork;

/*!
 *  是否是 WiFi 网络
 *
 *  @return YES, 反之:NO
 */
+ (BOOL)WY_isWiFiNetwork;

#pragma mark - 取消 Http 请求
/*!
 *  取消所有 Http 请求
 */
+ (void)WY_cancelAllRequest;

/*!
 *  取消指定 URL 的 Http 请求
 */
+ (void)WY_cancelRequestWithURL:(NSString *)URL;


@end
