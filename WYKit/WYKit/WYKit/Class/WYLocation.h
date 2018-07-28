//
//  WYLocation.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

@interface WYLocationObj : NSObject
/** 国家 */
@property (nonatomic, copy) NSString *country;
/** 省 直辖市 */
@property (nonatomic, copy) NSString *administrativeArea;
/** 地级市 直辖市区 */
@property (nonatomic, copy) NSString *locality;
/** 县 区 */
@property (nonatomic, copy) NSString *subLocality;
/** 街道 */
@property (nonatomic, copy) NSString *thoroughfare;
/** 子街道 */
@property (nonatomic, copy) NSString *subThoroughfare;
/** 经度 */
@property (nonatomic, assign) CLLocationDegrees longitude;
/** 纬度 */
@property (nonatomic, assign) CLLocationDegrees latitude;
@end

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol WYLocationDelegate <NSObject>

/** 代理方法 获取当前地理位置成功 如果代理方法和block同时实现会优先使用bolck回调 */
- (void)locationDidEndUpdatingLocation:(WYLocationObj *)locationObj;

/** 代理方法 获取地理位置失败 如果代理方法和block同时实现会优先使用bolck回调 */
- (void)locationdidFailWithError:(NSError *)failure;

@end

typedef void(^locationSuccessHandler)(WYLocationObj *locationObj);
typedef void(^locationFailureHandler)(NSError *error);
@interface WYLocation : NSObject

@property (nonatomic, weak) id<WYLocationDelegate> delegate;

/** 获取定位信息 */
@property (nonatomic, strong, readonly) WYLocationObj *locationObj;

/** 单利初始化方法 */
+ (instancetype)shardLocationManger;

/** 定位失败 跳转修改系统权限 */
- (void)requetModifySystemForPermissions;

/** 监测 是否拥有定位权限 */
- (BOOL)locationServicesEnabled;

/** 初始化开始定位 */
- (void)beginUpdatingLocation;

/** 初始化开始定位并且block回调 */
- (void)beginUpdatingLocationSuccess:(locationSuccessHandler)success
                             failure:(locationFailureHandler)failure;


@end
