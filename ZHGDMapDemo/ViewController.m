//
//  ViewController.m
//  ZHGDMapDemo
//
//  Created by zhanghua0221 on 17/3/8.
//  Copyright © 2017年 zhanghua0221. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong ,nonatomic) CLGeocoder *geoCoder;

//逆地理编码
@property (strong ,nonatomic) UITextField *laLabel;//纬度
@property (strong ,nonatomic) UITextField *loLabel;//经度
@property (strong ,nonatomic) UILabel *currentAdLabel;//当前地址
@property (strong ,nonatomic) UILabel *adLabel;//逆地理编码获取地址

//地理编码
@property (strong ,nonatomic) UILabel *searchLabel;//待编译纬度
@property (strong ,nonatomic) UILabel *searchLobel;//待编译经度
@property (strong ,nonatomic) UITextField *textField;//待编译地址

//两点间距离
@property (strong ,nonatomic) UITextField *adOne;//位置1
@property (strong ,nonatomic) UITextField *adTwo;//位置2
@property (strong ,nonatomic) NSArray *adArray;//保存地址 名称
@property (strong ,nonatomic) NSMutableArray *LcArray;//保存位置CLLocation 对象


@property (strong ,nonatomic) CLLocation *LocationOne;//保存地址 1
@property (strong ,nonatomic) CLLocation *LocationTwo;//保存地址 2

@property (strong ,nonatomic) UILabel *adDistance;//两地距离






@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    ///把地图添加至view
    //[self.view addSubview:_mapView];
    
    self.LcArray = [[NSMutableArray alloc] init];
    
    [self configLocationManager];
    
    [self creatLable];
    
}
- (CLGeocoder *)geoCoder
{
    if (!_geoCoder) {
        _geoCoder = [[CLGeocoder alloc] init];
    }
    return _geoCoder;
}
- (void)configLocationManager{
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    self.locationManager.delegate = self ;
    //开始定位
    [self.locationManager startUpdatingLocation];
}
-(void)creatLable{
    
//逆地理编码UI
    
    UIButton *btnOne = [UIButton buttonWithType:UIButtonTypeCustom];
    btnOne.frame = CGRectMake(0, 30, 100, 30);
    [btnOne setTitle:@"逆地理编码" forState:UIControlStateNormal];
    btnOne.backgroundColor = [UIColor orangeColor];
    [btnOne addTarget:self action:@selector(ClickOne) forControlEvents:UIControlEventTouchUpInside];
    
    self.laLabel = [[UITextField alloc]initWithFrame:CGRectMake(20, 130, 160, 30)];
    self.laLabel.backgroundColor = [UIColor orangeColor];
    self.laLabel.placeholder = @"请输入纬度";
    self.loLabel = [[UITextField alloc]initWithFrame:CGRectMake(200, 130, 160, 30)];
    self.loLabel.backgroundColor = [UIColor grayColor];
    self.loLabel.placeholder = @"请输入经度";
    self.laLabel.textAlignment = NSTextAlignmentCenter ;
    self.loLabel.textAlignment = NSTextAlignmentCenter ;
    
    self.currentAdLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 340, 30)];
    self.currentAdLabel.backgroundColor = [UIColor cyanColor];
    
    self.adLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 180, 340, 30)];
    self.adLabel.backgroundColor = [UIColor cyanColor];
    
    
    [self.view addSubview:btnOne];
    [self.view addSubview:self.laLabel];
    [self.view addSubview:self.loLabel];
    [self.view addSubview:self.currentAdLabel];
    [self.view addSubview:self.adLabel];
    
//地理编码UI
    
    UIButton *btnTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTwo.frame = CGRectMake(0, 220, 100, 30);
    [btnTwo setTitle:@"地理编码" forState:UIControlStateNormal];
    btnTwo.backgroundColor = [UIColor orangeColor];
    [btnTwo addTarget:self action:@selector(ClickTwo) forControlEvents:UIControlEventTouchUpInside];
    
    self.textField = [[UITextField alloc]init];
    self.textField.frame = CGRectMake(20, 270, 340, 30);
    self.textField.backgroundColor = [UIColor cyanColor];
    self.textField.placeholder = @"请输入地址";
    self.textField.textAlignment = NSTextAlignmentCenter ;


    self.searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 320, 160, 30)];
    self.searchLabel.backgroundColor = [UIColor orangeColor];
    
    self.searchLobel = [[UILabel alloc]initWithFrame:CGRectMake(200, 320, 160, 30)];
    self.searchLobel.backgroundColor = [UIColor grayColor];

    [self.view addSubview:btnTwo];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.searchLobel];
    [self.view addSubview:self.searchLabel];
    
//计算两点间距离
    UIButton *btnThree = [UIButton buttonWithType:UIButtonTypeCustom];
    btnThree.frame = CGRectMake(0, 370, 100, 30);
    [btnThree setTitle:@"两点间距离" forState:UIControlStateNormal];
    btnThree.backgroundColor = [UIColor orangeColor];
    [btnThree addTarget:self action:@selector(ClickThree) forControlEvents:UIControlEventTouchUpInside];
    
    self.adOne = [[UITextField alloc]initWithFrame:CGRectMake(20, 420, 160, 30)];
    self.adOne.backgroundColor = [UIColor orangeColor];
    self.adOne.placeholder = @"请输入地址";
    self.adTwo = [[UITextField alloc]initWithFrame:CGRectMake(200, 420, 160, 30)];
    self.adTwo.backgroundColor = [UIColor grayColor];
    self.adTwo.placeholder = @"请输入地址";
    self.adOne.textAlignment = NSTextAlignmentCenter ;
    self.adTwo.textAlignment = NSTextAlignmentCenter ;
    
    self.adDistance = [[UILabel alloc]initWithFrame:CGRectMake(20, 470, 340, 30)];
    self.adDistance.backgroundColor = [UIColor cyanColor];
    
    
    [self.view addSubview:btnThree];
    [self.view addSubview:self.adOne];
    [self.view addSubview:self.adTwo];
    [self.view addSubview:self.adDistance];
    
    
}

/**
 测试两点间的距离按钮
 
 */
-(void)ClickThree{
    
    self.adArray = [NSArray arrayWithObjects:self.adOne.text,self.adTwo.text,nil];
    
        [self.geoCoder geocodeAddressString:self.adArray[0] completionHandler:^(NSArray *placemarks, NSError *error) {
            
            
            NSLog(@"%@",self.adArray[0]);

            if (placemarks.count == 0 || error != nil) {
                return ;
            }
            CLPlacemark *placemark = placemarks[0];
            CLLocation *LocationOne = [[CLLocation alloc]initWithLatitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude];
            [self.LcArray addObject:LocationOne];
            
            [self getCLLocation];
            NSLog(@"latitude==%f", LocationOne.coordinate.latitude);
            NSLog(@"longitude==%f",LocationOne.coordinate.longitude);

        }];
    
}
-(void)getCLLocation{
    
    [self.geoCoder geocodeAddressString:self.adArray[1] completionHandler:^(NSArray *placemarks, NSError *error) {
        
        
        NSLog(@"%@",self.adArray[1]);
        
        if (placemarks.count == 0 || error != nil) {
            return ;
        }
        CLPlacemark *placemark = placemarks[0];
        CLLocation *LocationTwo = [[CLLocation alloc]initWithLatitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude];
        [self.LcArray addObject:LocationTwo];
        
        NSLog(@"latitude==%f", LocationTwo.coordinate.latitude);
        NSLog(@"longitude==%f",LocationTwo.coordinate.longitude);
        
        double  distance  = [self.LcArray[0] distanceFromLocation:self.LcArray[1]];
        self.adDistance.text = [NSString stringWithFormat:@"%f",distance/1000];
    }];
    
}
/**
 地理编码按钮
 
 */
-(void)ClickTwo{
    
    [self.geoCoder geocodeAddressString:self.textField.text completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (placemarks.count == 0 || error != nil) {
            return ;
        }
        CLPlacemark *placemark = [placemarks firstObject];
        
        self.searchLabel.text = [NSString stringWithFormat:@"%f", placemark.location.coordinate.latitude];
        self.searchLobel.text = [NSString stringWithFormat:@"%f", placemark.location.coordinate.longitude];
    }];
    
}

/**
 逆地理编码按钮
 
 */
-(void)ClickOne{
    
    //创建位置
    CLLocation *localtion = [[CLLocation alloc]initWithLatitude:[self.laLabel.text floatValue] longitude:[self.loLabel.text floatValue]];
    
    [self.geoCoder reverseGeocodeLocation:localtion completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error != nil ||  placemarks.count == 0) {
            return ;
        }
        for (CLPlacemark *placeMark in placemarks) {
            //赋值详细地址
            self.adLabel.text = placeMark.name;
        }
    }];
}

/**
 定位错误

 */
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}
/**
 定位 获取经纬度

 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    
//定位结果 获取 经纬度
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    
//当前经纬度Lable赋值
    self.currentAdLabel.text = [NSString stringWithFormat:@"当前纬度=%f,当前经度=%f",location.coordinate.latitude,location.coordinate.longitude];
    
    
//逆地理编码 获取 具体地址
    //Geocoding Block
    [self.geoCoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         for (CLPlacemark *placeMark in placemarks)
         {
             NSDictionary *addressDic=placeMark.addressDictionary;
//           //城市
//           NSString *state=[addressDic objectForKey:@"State"];
             //城市
             self.city=[addressDic objectForKey:@"City"];
             //区县
             self.subLocality=[addressDic objectForKey:@"SubLocality"];
             //街道
             self.street=[addressDic objectForKey:@"Street"];
         }
     }];
    
}
/**
 收起键盘
 
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.textField resignFirstResponder];
    [self.laLabel resignFirstResponder];
    [self.loLabel resignFirstResponder];
    [self.adOne resignFirstResponder];
    [self.adTwo resignFirstResponder];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

@end
