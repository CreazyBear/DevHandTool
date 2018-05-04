//
//  FJBlueToothManager.m
//  DevHandTool
//
//  Created by bearger on 2018/3/28.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import "FJBlueToothManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "FJBlueToothPeripheralInfoModel.h"
#import <Cocoa/Cocoa.h>
#import <CoreLocation/CoreLocation.h>


static NSString * const kCharacteristicUUID = @"6789";
static NSString * const kServiceUUID = @"FFEE";

@interface FJBlueToothManager() <CBCentralManagerDelegate,CBPeripheralDelegate,CBPeripheralManagerDelegate>
@property (nonatomic, strong) CBCentralManager *myCentralManager;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) BOOL scanFlag;
@end

@implementation FJBlueToothManager
SINGLETON_IMPLEMENTION(FJBlueToothManager, singletonInstance)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.myCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
        [self addObserver:self forKeyPath:@"myCentralManager.state" options:(NSKeyValueObservingOptionNew) context:nil];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    id oldName = [change objectForKey:NSKeyValueChangeOldKey];
    NSInteger newName = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
    if (newName == 5 && self.scanFlag) {
        [self.myCentralManager scanForPeripheralsWithServices:nil options:nil];
    }
}

#pragma mark - public
-(void)bind:(id)delegate {
    self.delegate = delegate;
}

-(void)unbind {
    self.delegate = nil;
    [self.myCentralManager stopScan];
}

-(void)start {
    self.scanFlag = YES;
    if (self.myCentralManager.state == CBCentralManagerStatePoweredOn) {
        [self.myCentralManager scanForPeripheralsWithServices:nil options:nil];
    }
}

-(void)stop {
    self.scanFlag = NO;
    [self.myCentralManager stopScan];
    [self.peripheralManager stopAdvertising];
}

-(void)reset {
    self.delegate = nil;
    self.myCentralManager = nil;
    self.scanFlag = NO;
    [self removeObserver:self forKeyPath:@"myCentralManager.state"];
}

-(void)startBroadcast {
    
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

-(void)connectDevices:(FJBlueToothPeripheralInfoModel*)model {
    if (model) {
        [self.myCentralManager connectPeripheral:model.peripheral options:nil];
    }
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    if (self.myCentralManager.state == CBCentralManagerStatePoweredOn) {
        [self.myCentralManager scanForPeripheralsWithServices:nil options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central
      willRestoreState:(NSDictionary<NSString *, id> *)dict {

}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary<NSString *, id> *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    if (peripheral.name) {
        FJBlueToothPeripheralInfoModel * model = [FJBlueToothPeripheralInfoModel new];
        model.peripheral = peripheral;
        model.advertisementData = advertisementData;
        model.RSSI = RSSI;
        model.name = peripheral.name;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDiscoverPeripheral:)]) {
            [self.delegate didDiscoverPeripheral:model];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didConnectDevices:)]) {
        FJBlueToothPeripheralInfoModel * model = [FJBlueToothPeripheralInfoModel new];
        model.peripheral = peripheral;
        [self.delegate didConnectDevices:model];
    }
}

- (void)centralManager:(CBCentralManager *)central
didFailToConnectPeripheral:(CBPeripheral *)peripheral
                 error:(nullable NSError *)error {
    
}

- (void)centralManager:(CBCentralManager *)central
didDisconnectPeripheral:(CBPeripheral *)peripheral
                 error:(nullable NSError *)error {
    
}

#pragma mark - CBPeripheralDelegate

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices {
    
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {

}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
   
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    
}

- (void)peripheralIsReadyToSendWriteWithoutResponse:(CBPeripheral *)peripheral {
    
}

#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    if (error == nil) {
        //添加服务后可以在此向外界发出通告 调用完这个方法后会调用代理的
        //(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
        [peripheral startAdvertising:@{CBAdvertisementDataLocalNameKey : @"BeargerHunter",
                                       CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:kServiceUUID]]
                                       }];
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    NSLog(@"in peripheralManagerDidStartAdvertisiong:error");
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    switch (peripheral.state) {
            //在这里判断蓝牙设别的状态  当开启了则可调用  setUp方法(自定义)
        case CBPeripheralManagerStatePoweredOn:
        {
            NSLog(@"powered on");
            CBMutableCharacteristic *customerCharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:kCharacteristicUUID]
                                                                                                properties:CBCharacteristicPropertyNotify
                                                                                                     value:nil
                                                                                               permissions:CBAttributePermissionsReadable];
            CBUUID *serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
            CBMutableService *customerService = [[CBMutableService alloc]initWithType:serviceUUID primary:YES];
            
            [customerService setCharacteristics:@[customerCharacteristic]];
            
            [peripheral addService:customerService];
        }
            
            
            break;
        case CBPeripheralManagerStatePoweredOff:
            NSLog(@"powered off");
            break;
            
        default:
            break;
    }
}

@end
