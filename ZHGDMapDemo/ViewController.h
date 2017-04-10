//
//  ViewController.h
//  ZHGDMapDemo
//
//  Created by zhanghua0221 on 17/3/8.
//  Copyright © 2017年 zhanghua0221. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController<AMapLocationManagerDelegate,UITextFieldDelegate>

@property (strong ,nonatomic) MAMapView *mapView;
@property (strong ,nonatomic) AMapLocationManager *locationManager;

@property (copy ,nonatomic) NSString *city;//城市
@property (copy ,nonatomic) NSString *subLocality;//区县
@property (copy ,nonatomic) NSString *street;//街道

@end

