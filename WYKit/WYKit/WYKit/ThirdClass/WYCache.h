//
//  WYCache.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

@interface WYCache : NSObject

/** 存储网络数据缓存 */
+ (void)saveDataCache:(id)data forKey:(NSString *)key;

/** 读取缓存 */
+ (id)readCache:(NSString *)key ;

/** 获取缓存总大小 */
+ (void)getAllCacheSize;

/** 删除指定缓存 */
+ (void)removeChache:(NSString *)key;

/** 删除全部缓存 */
+ (void)removeAllCache;


@end
