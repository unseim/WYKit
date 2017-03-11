//
//  WYCache.h
//  WYKit
//
//  Created by 汪年成 on 16/12/26.
//  Copyright © 2016年 之静之初. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYCache : NSObject

/**
 存储缓存
 
 @param data 网络数据
 @param key key
 */
+ (void)saveDataCache: (id)data forKey:(NSString *)key;

/**
 读取缓存
 
 @param key key
 */
+ (id)readCache:(NSString *)key ;

/**
 获取缓存总大小
 */
+ (void)getAllCacheSize;

/**
 删除指定缓存
 
 @param key key
 */
+ (void)removeChache:(NSString *)key;

/**
 删除全部缓存
 */
+ (void)removeAllCache;


@end
