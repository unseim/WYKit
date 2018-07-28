//
//  WYBluetoothManager.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYBluetoothManager.h"
#define SCANCUTDOWNTIME 45.0f //查找蓝牙设备超时时间

@interface WYBluetoothManager ()
<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic, assign) BLESTATUE bleStatue;

@property (nonatomic, strong) NSString *serviceUUID;
@property (nonatomic, strong) NSString *outputCharacteristicUUID;
@property (nonatomic, strong) NSString *inputCharacteristicUUID;

@property (nonatomic, strong) CBCentralManager *centralManager;//蓝牙管理
@property (nonatomic, strong) CBPeripheral *peripheral;//连接的设备信息
@property (nonatomic, strong) CBService *service;//当前服务
@property (nonatomic, strong) CBCharacteristic *inputCharacteristic;//连接的设备特征（通道）输入
@property (nonatomic, strong) CBCharacteristic *outPutcharacteristic;//连接的设备特征（通道）输出

@property (nonatomic, strong) NSTimer *scanCutdownTimer; //查找设备倒计时
@property (nonatomic, strong) NSMutableArray *mPeripherals;//找到的设备

@end

@implementation WYBluetoothManager

static WYBluetoothManager *_instance = nil;
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[WYBluetoothManager alloc]init];
        _instance.bleStatue = BLESTATUE_UNKNOW;
        _instance.centralManager = [[CBCentralManager alloc] initWithDelegate:_instance queue:nil];
    });
    return _instance;
}

#pragma mark - 蓝牙状态
- (BLESTATUE)getBLEStatue
{
    return _instance.bleStatue;
}

//  手机蓝牙状态 0，未知 1，重置中 2，不支持 3，非法 4，关闭 5，开启
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [_instance updateBLEStatue:(int)central.state];
}

#pragma mark - 查找蓝牙
- (void)scanDevice
{
    if (!_instance.centralManager) {
        _instance.centralManager = [[CBCentralManager alloc] initWithDelegate:_instance queue:nil];
    }
    [_instance stopScanDevice];
    [_instance disconnectDevice];
    _instance.mPeripherals = [[NSMutableArray alloc]init];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_instance.centralManager.state == CBCentralManagerStatePoweredOn)
        {   //  开始搜索蓝牙设备
            [_centralManager scanForPeripheralsWithServices:nil options:nil];
            [_instance updateBLEStatue:BLESTATUE_DEVICE_SEARCH];
            _instance.scanCutdownTimer = [NSTimer scheduledTimerWithTimeInterval:SCANCUTDOWNTIME target:_instance selector:@selector(stopScanDevice) userInfo:nil repeats:NO];
        }else{
            [_instance updateBLEStatue:(int)_instance.centralManager.state];
        }
        
    });
}

//  找到设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"找到蓝牙设备 %@",peripheral);
    if (![_instance.mPeripherals containsObject:peripheral]) {
        [_instance.mPeripherals addObject:peripheral];
        if (_instance.delegate && [_instance.delegate respondsToSelector:@selector(updateDevices:)]) {
            [_instance.delegate updateDevices:_instance.mPeripherals];
        }
    }
}

//  停止查找设备
- (void)stopScanDevice
{
    if (_instance.centralManager) {
        [_centralManager stopScan];
    }
    if (_instance.bleStatue == BLESTATUE_DEVICE_SEARCH) {
        [_instance updateBLEStatue:BLESTATUE_DEVICE_NOTFIND];
    }
    [_instance.scanCutdownTimer invalidate];
}

#pragma mark - 蓝牙连接

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
           andInputCharacteristicUUID:(NSString *)inputcharacteristicUUID
{
    _instance.peripheral = peripheral;
    _instance.serviceUUID = serviceUUID;
    _instance.outputCharacteristicUUID = outputcharacteristicUUID;
    _instance.inputCharacteristicUUID = inputcharacteristicUUID;
    
    [_instance reConnectDevice];
    
}

//  重新连接
- (void)reConnectDevice
{
    if (!_instance.peripheral || ![_instance.serviceUUID length] || ![_instance.outputCharacteristicUUID length] || ![_instance.inputCharacteristicUUID length]) {
        [_instance updateBLEStatue:BLESTATUE_CONNECT_FAIL];
        return;
    }
    [_instance stopScanDevice];
    [_instance disconnectDevice];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_instance.centralManager connectPeripheral:_instance.peripheral options:nil];
    });
    //  开始连接蓝牙设备
    [_instance updateBLEStatue:BLESTATUE_CONNECT_ING];
}

//  重新成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //  开始查找蓝牙服务
    _instance.service = nil;
    _inputCharacteristic = nil;
    _outPutcharacteristic = nil;
    _instance.peripheral = peripheral;
    _instance.peripheral.delegate = _instance;
    [_instance.peripheral discoverServices:nil];
    [_instance updateBLEStatue:BLESTATUE_SERVICE_ING];
}

//  重新失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    [_instance updateBLEStatue:BLESTATUE_CONNECT_FAIL];
}

//  发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"发现服务： %@ 错误： %@", peripheral.name, [error localizedDescription]);
        [_instance updateBLEStatue:BLESTATUE_SERVICE_FAIL];
        return;
    }
    NSLog(@"发现服务：%@",peripheral.services);
    for (CBService *service in peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:_instance.serviceUUID]]) {
            _instance.service = service;
            dispatch_async(dispatch_get_main_queue(), ^{
                //  开始查找服务通道
                [peripheral discoverCharacteristics:nil forService:_instance.service];
            });
            [_instance updateBLEStatue:BLESTATUE_CHARACT_ING];
            break;
        }
    }
}

//  发现特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"发现特征： %@ 错误: %@", peripheral.name, [error localizedDescription]);
        [_instance updateBLEStatue:BLESTATUE_CHARACT_FAIL];
        return;
    }
    NSLog(@"发现特征：%@",service.characteristics);
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:_outputCharacteristicUUID]]) {
            _outPutcharacteristic = characteristic;
        }
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:_inputCharacteristicUUID]]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            [peripheral readValueForCharacteristic:characteristic];
            _inputCharacteristic = characteristic;
        }
        if (_outPutcharacteristic && _inputCharacteristic) {
            [_instance updateBLEStatue:BLESTATUE_CHARACT_USEFUL];
            break;
        }
    }
}


#pragma mark - 蓝牙断开

//  断开蓝牙连接
- (void)disconnectDevice{
    if (_instance.peripheral) {
        [_instance.centralManager cancelPeripheralConnection:_instance.peripheral];
    }
    
}

//  接收断开连接状态
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [_instance updateBLEStatue:BLESTATUE_CONNECT_DIS];
}


#pragma mark - 发送及接收消息

//  发送消息
- (void)sendMsg:(NSData* )msg
{
    if (msg) {
        [_instance.peripheral writeValue:msg forCharacteristic:_outPutcharacteristic type:CBCharacteristicWriteWithoutResponse];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didWriteValueForCharacteristic -> %@",characteristic);
}

//  接收数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"接收数据错误：%@",[error localizedDescription]);
        return;
    }
    NSLog(@"接收到的数据：%@",characteristic.value);
    if (_instance.delegate && [_instance.delegate respondsToSelector:@selector(revicedMessage:)]) {
        [_instance.delegate revicedMessage:characteristic.value];
    }
}

#pragma mark - helper
- (void)updateBLEStatue:(BLESTATUE)statue
{
    _instance.bleStatue = statue;
    if (_instance.delegate && [_instance.delegate respondsToSelector:@selector(updateStatue:)]) {
        [_instance.delegate updateStatue:_instance.bleStatue];
    }
    NSLog(@"蓝牙状态为 %d", (int)_instance.bleStatue);
}

@end
