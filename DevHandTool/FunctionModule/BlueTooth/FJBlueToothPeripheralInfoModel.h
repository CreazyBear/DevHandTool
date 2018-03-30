//
//  FJBlueToothPeripheralInfoModel.h
//  DevHandTool
//
//  Created by bearger on 2018/3/28.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface FJBlueToothPeripheralInfoModel : NSObject
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDictionary *advertisementData;
@property (nonatomic, strong) NSNumber *RSSI;
@end
