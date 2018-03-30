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

@interface FJBlueToothManager() <CBCentralManagerDelegate,CBPeripheralDelegate>
@property(nonatomic, strong) CBCentralManager *myCentralManager;
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
}

-(void)reset {
    self.delegate = nil;
    self.myCentralManager = nil;
    self.scanFlag = NO;
    [self removeObserver:self forKeyPath:@"myCentralManager.state"];
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

@end
