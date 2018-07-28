//
//  NSFileManager+WYKit.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

@interface NSFileManager (WYKit)

#pragma mark - 各种路径及URL
/** 获取URL */
+ (NSURL *)documentsURL;

/** 获取Documents目录路径 */
+ (NSString *)documentsPath;

/** 获取Library目录URL */
+ (NSURL *)libraryURL;

/** 获取Library目录路径 */
+ (NSString *)libraryPath;

/** 获取Cache目录URL */
+ (NSURL *)cachesURL;

/** 获取Cache目录路径 */
+ (NSString *)cachesPath;

/** 获取应用沙盒根路径 */
+ (NSString *)homePath;

/** 获取Tmp目录路径 */
+ (NSString *)tmpPath;


#pragma mark - 各种方法

/** 判断文件是否存在于沙盒中 */
- (BOOL)isFileExists:(NSString *)filePath;

/** 判断文件是否超时 */
- (BOOL)isFile:(NSString *)filePath timeout:(NSTimeInterval)timeout;

@end
