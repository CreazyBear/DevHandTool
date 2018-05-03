//
//  FJMapVC.m
//  DevHandTool
//
//  Created by 熊伟 on 2018/5/3.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import "FJMapVC.h"


@interface FJMapVC ()<MKMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation FJMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setupMapView];
}

-(void)setupMapView {
    MKCoordinateSpan span;
    span.latitudeDelta = 0.077919;
    span.longitudeDelta = 0.044529;
    
    MKCoordinateRegion region ;
    region.center = CLLocationCoordinate2DMake(30.245853, 120.209947);
    region.span = span;
    
    //设置显示区域
    [_mapView setRegion:region];
    //显示定位
    _mapView.showsUserLocation = YES;
    _mapView.showsCompass = YES;
    _mapView.showsScale = YES;
    _mapView.delegate = self;
    
}

-(CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.distanceFilter = 5;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
    }
    return _locationManager;
}



#pragma mark - MKMapViewDelegate
/**
 *  当地图获取到用户位置时调用
 *
 *  @param mapView      地图
 *  @param userLocation 大头针数据模型
 */
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    /**
     *  MKUserLocation : 专业术语: 大头针模型 其实喊什么都行, 只不过这个类遵循了大头针数据模型必须遵循的一个协议 MKAnnotation
     // title : 标注的标题
     // subtitle : 标注的子标题
     */
    userLocation.title = @"熊大";
    userLocation.subtitle = @"坐在角落看世界";
    
    // 移动地图的中心,显示用户的当前位置
    //    [mapView setCenterCoordinate:userLocation.location.coordinate an、、imated:YES];
    // 控制区域中心
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    // 设置区域跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(0.077919, 0.044529);
    // 创建一个区域
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    // 设置地图显示区域
    [mapView setRegion:region animated:YES];
}


/**
 *  地图区域将要改变时调用
 *
 *  @param mapView  地图
 *  @param animated 动画
 */
-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    //当zoom变化时，我们需要将annotation进行合并
}

/**
 *  地图区域已经改变时调用 --- 先缩放 获取经纬度跨度，根据经纬度跨度显示区域
 *
 *  @param mapView  地图
 *  @param animated 动画
 */
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
}

//添加overlay后，使用此回调添加 view
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView
           rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        renderer.strokeColor = [NSColor blueColor];
        renderer.lineWidth = 5.0;
        return renderer;
    }
    return nil;
}

//map 根据添加的annotation obj 创建 annotation view
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    return nil;
}

//拖拽annotation
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
}

//点击call out 右边的button时的回调
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(NSControl *)control {
    
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
}

-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered{
    
}


#pragma mark - CLLocationManagerDelegate
//定位成功后的回调
// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
}

//定位失败后的回调
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

//当location manager暂停定位时调用
-(void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    
}

//当location manager重新开启定位时调用
-(void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
    
}

//进入监控区间
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
}

//离开监控区间
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
}

//无法添加监控区间
-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    
}

//方向感觉回调
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy < 0)
        return;
    
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
    
}

@end
