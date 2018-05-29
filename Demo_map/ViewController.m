//
//  ViewController.m
//  Demo_map
//
//  Created by MC on 2018/5/4.
//  Copyright © 2018年 MC. All rights reserved.
//

#import "ViewController.h"

#import <MapKit/MapKit.h>
#import "YYAnnotation.h"

@interface ViewController () <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView * mapView;
@property(strong,nonatomic)MKMapItem *mapItem;
@property(strong,nonatomic)CLGeocoder *geocoder;
@property(strong,nonatomic)MKDirections *direct;

@end

@implementation ViewController




- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
//    //创建一个系统大头针对象
//
//    MKPinAnnotationView * view = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
//    view.animatesDrop = true;
//
//    if ([annotation.title isEqualToString:@"我"]) {
//        view.pinTintColor = [UIColor redColor];//设置颜色为绿色
//
//    } else {
//        view.pinTintColor = [UIColor greenColor];//设置颜色为绿色
//
//    }
    
    
    //设置标注的图片
    MKAnnotationView * view = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];

    view.image = [UIImage imageNamed:@"120"];
    
    //点击显示图详情视图 必须MKPointAnnotation对象设置了标题和副标题
    
    view.canShowCallout=YES;
    
    //创建了两个view
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    view1.backgroundColor=[UIColor redColor];
    
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    view2.backgroundColor=[UIColor blueColor];
    
    //设置左右辅助视图
    view.leftCalloutAccessoryView=view1;
    view.rightCalloutAccessoryView=view2;
    
    //设置拖拽 可以通过点击不放进行拖拽
    
    view.draggable=YES;
    
    
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _geocoder = [[CLGeocoder alloc]init];
    
    [_geocoder geocodeAddressString:@"白石洲" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        
        MKPlacemark *placemark = [[MKPlacemark alloc]initWithPlacemark:placemarks.lastObject];
        //intrItem可以理解为地图上的一个点
        MKMapItem *intrItem = [[MKMapItem alloc]initWithPlacemark:placemark];
        
        //        添加一个小别针到地图上
        MKPointAnnotation *anno = [[MKPointAnnotation alloc]init];
        anno.coordinate = intrItem.placemark.location.coordinate;
        anno.title = @"我";
        anno.subtitle = @"我的位置";
        [self.mapView addAnnotation:anno];
        
       //  让地图跳转到起点所在的区域
        MKCoordinateRegion region = MKCoordinateRegionMake(intrItem.placemark.location.coordinate, MKCoordinateSpanMake(0.1, 0.1));
        [self.mapView setRegion:region];
        
        
        
        //创建终点
        [_geocoder geocodeAddressString:@"深圳北站" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            //destItem可以理解为地图上的一个点
            MKMapItem *destItem = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithPlacemark:[placemarks lastObject]]];
            
            
            //        添加一个小别针到地图上
            MKPointAnnotation *anno = [[MKPointAnnotation alloc]init];
            anno.title = @"我";
            anno.subtitle = @"我的位置";
            anno.coordinate = destItem.placemark.location.coordinate;
            [self.mapView addAnnotation:anno];
            
            [self.mapView selectAnnotation:anno animated:true];
            //调用下面方法发送请求
            [self moveWith:intrItem toDestination:destItem];
        }];
    }];
    
    
    [self.view addSubview:self.mapView];
    
    /*** 地图的样式
     typedef NS_ENUM(NSUInteger, MKMapType) {
     MKMapTypeStandard = 0,//标准式的行政地图(会显示城市，街道等)
     MKMapTypeSatellite,//标准的卫星地图
     MKMapTypeHybrid//混合地图(在卫星图上显示街道等名称)
     };
     */
    self.mapView.mapType = MKMapTypeStandard;

    /** 设置地图的中心位置和比例尺是通过region这个属性实现的
     typedef struct {
     CLLocationCoordinate2D center;//地图中心的经纬度
     MKCoordinateSpan span;//地图显示的经纬度范围
     } MKCoordinateRegion;
     这个结构体中包含了两个结构体，其中CLLocationCoordinate2D很好理解，就是简单的经纬度，解释如下：
     
     typedef struct {
     CLLocationDegrees latitude;//纬度，北纬为正，南纬为负
     CLLocationDegrees longitude;//经度，东经为正，西经为负
     } CLLocationCoordinate2D;
     MKCoordinateSpan这个结构体比较复杂，如下：
     
     typedef struct {
     CLLocationDegrees latitudeDelta;//纬度范围
     CLLocationDegrees longitudeDelta;//经度范围
     } MKCoordinateSpan;
     
     
     */
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.26, 116.3);

    MKCoordinateSpan span = MKCoordinateSpanMake(0.111111, 0.111111);
    self.mapView.region = MKCoordinateRegionMake(coordinate, span);
//    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, span) animated:true];
    
    /** 设置中心点
     */
    self.mapView.centerCoordinate = coordinate;
    
    
    /**  是否显示用户位置
     typedef NS_ENUM(NSInteger, MKUserTrackingMode) {
     MKUserTrackingModeNone = 0, // 不跟踪用户位置
     MKUserTrackingModeFollow, // 跟踪用户位置
     MKUserTrackingModeFollowWithHeading, // 当方向改变时跟踪用户位置
     }
     
     - (void)setUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated;
     */
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    
    
    //初始化一个大头针类
    
    MKPointAnnotation * ann = [[MKPointAnnotation alloc]init];
    //设置大头针坐标
    ann.coordinate=CLLocationCoordinate2DMake(39.26, 116.3);
    ann.title=@"我";
    ann.subtitle=@"看这里";
    
    
    MKPointAnnotation * ann1 = [[MKPointAnnotation alloc]init];
    ann1.coordinate=CLLocationCoordinate2DMake(39.40, 116.3);
    ann1.title = @"商家";
    ann1.subtitle = @"去这里";
    
    
//
//    [self.mapView addAnnotations:@[ann,ann1]];
//    self.mapView.selectedAnnotations = @[ann,ann1];
////    [_mapView addAnnotation:ann];
}


- (MKMapView *)mapView {
    if (_mapView == nil) {
        self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
        self.mapView.delegate = self;
    } return _mapView;
}




//提供两个点，在地图上进行规划的方法
-(void)moveWith:(MKMapItem *)formPlce toDestination:(MKMapItem *)endPlace{
    
    //    创建请求体
    // 创建请求体 (起点与终点)
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = formPlce;
    request.destination = endPlace;
    
    self.direct = [[MKDirections alloc]initWithRequest:request];
    
    // 计算路线规划信息 (向服务器发请求)
    [self.direct calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        
        //获取到所有路线
        NSArray <MKRoute *> *routesArray = response.routes;
        //取出最后一条路线
        MKRoute *rute = routesArray.lastObject;
        
        //路线中的每一步
        NSArray <MKRouteStep *>*stepsArray = rute.steps;
        
        //遍历
        for (MKRouteStep *step in stepsArray) {
            
            [self.mapView addOverlay:step.polyline];
        }
        // 收响应结果 MKDirectionsResponse
        // MKRoute 表示的一条完整的路线信息 (从起点到终点) (包含多个步骤)
    }];
    
}

// 返回指定的遮盖模型所对应的遮盖视图, renderer-渲染
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    // 判断类型
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        // 针对线段, 系统有提供好的遮盖视图
        MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        
        // 配置，遮盖线的颜色
        render.lineWidth = 5;
        render.strokeColor =  [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0];
        
        return render;
    }
    // 返回nil, 是没有默认效果
    return nil;
}




@end
