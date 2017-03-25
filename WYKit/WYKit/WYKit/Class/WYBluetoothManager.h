//
//  WYBluetoothManager.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSUInteger, BLESTATUE)
{
    BLESTATUE_UNKNOW = 0,     //未知
    BLESTATUE_RESETTING,      //重置中
    BLESTATUE_UNSUPPORT,      //不支持
    BLESTATUE_UNLAWFUL,       //非法
    BLESTATUE_COLSED,         //关闭
    BLESTATUE_OPENED,         //开启，但未连接蓝牙
    
    BLESTATUE_DEVICE_SEARCH,  //搜索中
    BLESTATUE_DEVICE_NOTFIND, //找不到设备
    
    BLESTATUE_CONNECT_ING,    //连接中
    BLESTATUE_CONNECT_FAIL,   //连接失败
    BLESTATUE_CONNECT_DIS,    //连接断开
    
    BLESTATUE_SERVICE_ING,    //获取服务中
    BLESTATUE_SERVICE_FAIL,   //获取服务失败
    
    BLESTATUE_CHARACT_ING,    //获取特征(通道)中
    BLESTATUE_CHARACT_FAIL,   //获取特征(通道)失败
    BLESTATUE_CHARACT_USEFUL, //特征(通道)可用
};

@protocol WYBluetoothManagerDelegate <NSObject>
@optional
/** 搜索到设备回调 */
- (void)updateDevices:(NSArray *)devices;

/** 蓝牙状态改变回调 */
- (void)updateStatue:(BLESTATUE)statue;
 
 /** 接受到数据回调 */
- (void)revicedMessage:(NSData *)msg;

@end

//  蓝牙使用步骤 ： 1，获取蓝牙管理器 2，查找蓝牙 3，连接蓝牙 4，收发数据
@interface WYBluetoothManager : NSObject

@property (nonatomic, weak) id<WYBluetoothManagerDelegate> delegate;

/** 单例 */
+ (instancetype)sharedManager;

/** 获取蓝牙状态 */
- (BLESTATUE)getBLEStatue;

/** 查找设备 */
- (void)scanDevice;

/** 停止查找设备 */
- (void)stopScanDevice;


/**
 *  连接设备
 *
 *  @param peripheral               设备信息
 *  @param serviceUUID              服务UUID
 *  @param outputcharacteristicUUID 写出特征UUID
 *  @param inputcharacteristicUUID  读入特征UUID
 *
 */
- (void)connectDeviceWithCBPeripheral:(CBPeripheral *)peripheral
                       andServiceUUID:(NSString *)serviceUUID
          andOutputCharacteristicUUID:(NSString *)outputcharacteristicUUID
           andInputCharacteristicUUID:(NSString *)inputcharacteristicUUID;

/** 重新连接 */
- (void)reConnectDevice;

/** 断开连接 */
- (void)disconnectDevice;

/** 发送消息 */
- (void)sendMsg:(NSData* )msg;

@end
