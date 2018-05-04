//
//  FJBlueToothVC.m
//  DevHandTool
//
//  Created by bearger on 2018/3/28.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import "FJBlueToothVC.h"
#import "FJBlueToothManager.h"
#import "FJBlueToothPeripheralInfoModel.h"


@interface FJBlueToothVC ()<FJBlueToothManagerDelegate>
@property (unsafe_unretained) IBOutlet NSTextView *scanResultTextView;

@end

@implementation FJBlueToothVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onScanButtonClicked:(id)sender {
    [[FJBlueToothManager singletonInstance] bind:self];
    [[FJBlueToothManager singletonInstance]start];
}

- (IBAction)onStopButtonClicked:(id)sender {
    [[FJBlueToothManager singletonInstance]stop];
}

- (IBAction)onBroadcastButtonClicked:(id)sender {
    [[FJBlueToothManager singletonInstance]startBroadcast];
}


#pragma mark - FJBlueToothManagerDelegate
-(void)didDiscoverPeripheral:(FJBlueToothPeripheralInfoModel *)model {
    NSString * info = [NSString stringWithFormat:@"Name:%@\nRSSI:%@\nAdvertisementData:%@\n------------",model.name,model.RSSI,model.advertisementData];
    [self appendContentToResultView:info];
    [[FJBlueToothManager singletonInstance]connectDevices:model];
}

-(void)didConnectDevices:(FJBlueToothPeripheralInfoModel*)model {
    
}

#pragma mark - utils
-(void)appendContentToResultView:(NSString*)str {
    NSString * content = [NSString stringWithFormat:@"%@\n%@",self.scanResultTextView.string,str];
    self.scanResultTextView.string = content;
}


@end
