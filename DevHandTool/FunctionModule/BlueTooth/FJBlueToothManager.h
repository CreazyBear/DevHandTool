//
//  FJBlueToothManager.h
//  DevHandTool
//
//  Created by bearger on 2018/3/28.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import <Foundation/Foundation.h>


@class FJBlueToothPeripheralInfoModel;

@protocol FJBlueToothManagerDelegate

-(void)didDiscoverPeripheral:(FJBlueToothPeripheralInfoModel*)model;


@end

@interface FJBlueToothManager : NSObject
SINGLETON_INTERFACE(FJBlueToothManager, singletonInstance)
-(void)bind:(id)delegate;
-(void)unbind;
-(void)start;
-(void)stop;
-(void)reset;
@end
