//
//  WYLocation.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYLocation.h"

@interface WYLocation () <CLLocationManagerDelegate>
@property (nonatomic, strong) WYLocationObj *location;
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, copy) locationSuccessHandler successHandler;
@property (nonatomic, copy) locationFailureHandler failureHandler;
@end

@implementation WYLocation

static id _instace = nil;

+ (instancetype)shardLocationManger
{
    return [[self alloc] init];
}

- (instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super init];
    });
    return _instace;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (_instace == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instace = [super allocWithZone:zone];
        });
    }
    return _instace;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return _instace;
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return _instace;
}

#pragma mark - 定位失败

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
#ifdef DEBUG
    NSLog(@"定位失败 !!");
#endif
    
    
    if (self.failureHandler)
    {
        self.failureHandler(error);
    } else
    {
        if ([self.delegate respondsToSelector:@selector(locationdidFailWithError:)])
        {
            [self.delegate locationdidFailWithError:error];
        }
    }
}

#pragma mark - Public

- (void)beginUpdatingLocation
{
    if ([self.locationManager respondsToSelector:@selector(startUpdatingLocation)]) {
        [self.locationManager startUpdatingLocation];
    }
    
    [self.locationManager requestWhenInUseAuthorization];
}

- (void)beginUpdatingLocationSuccess:(locationSuccessHandler)success
                             failure:(locationFailureHandler)failure
{
    [self beginUpdatingLocation];
    self.successHandler = success;
    self.failureHandler = failure;
}

- (void)requetModifySystemForPermissions
{
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([app canOpenURL:settingsURL]) {
        [app openURL:settingsURL];
    }
}

- (BOOL)locationServicesEnabled
{
    BOOL isLocation = [CLLocationManager locationServicesEnabled];  //是否开启定位服务
    if (!isLocation)
    {
        return NO;
    } else
    {
        CLAuthorizationStatus locationStatus = [CLLocationManager authorizationStatus];
        switch (locationStatus) {
            case kCLAuthorizationStatusNotDetermined: return NO; break; // 未询问用户是否授权
            case kCLAuthorizationStatusRestricted:  return NO;  break;  // 未授权，例如家长控制
            case kCLAuthorizationStatusDenied:  return NO;  break;      // 未授权，用户拒绝造成的
            case kCLAuthorizationStatusAuthorizedAlways: return YES; break;     // 同意授权一直获取定位信息
            case kCLAuthorizationStatusAuthorizedWhenInUse: return YES; break;  // 同意授权在使用时获取定位信息
            default: return NO; break;
        }
    }
}


#pragma mark - 定位成功

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation = locations.lastObject;
    self.location.longitude = currentLocation.coordinate.longitude;
    self.location.latitude = currentLocation.coordinate.latitude;
    
    //根据经纬度反向地理编译出地址信息
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
    {
        if (placemarks.count > 0)
        {
            CLPlacemark *placemark = placemarks.firstObject;
            self.location.country = placemark.country;
            self.location.administrativeArea = placemark.administrativeArea;
            self.location.locality = !placemark.locality ? placemark.administrativeArea : placemark.locality;
            self.location.subLocality = placemark.subLocality;
            self.location.thoroughfare = placemark.thoroughfare;
            self.location.subThoroughfare = placemark.subThoroughfare;
            
            
            
#ifdef DEBUG
            NSLog(@"city = %@, longitude = %lg, latitude = %lg", self.location.locality, self.location.longitude, self.location.latitude);
#endif
            
            if (self.successHandler)
            {
                self.successHandler(self.location);
            } else
            {
                if ([self.delegate respondsToSelector:@selector(locationDidEndUpdatingLocation:)])
                {
                    [self.delegate locationDidEndUpdatingLocation:self.location];
                }
            }
        }
    }];
    
    [manager stopUpdatingLocation];
}


#pragma mark - setter and getter

- (WYLocationObj *)locationObj
{
    return self.location;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 1000;
    }
    return _locationManager;
}

- (WYLocationObj *)location{
    if(!_location){
        _location = [[WYLocationObj alloc]init];
    }
    return _location;
}
@end


@implementation WYLocationObj

@end
