//
//  ViewController.h
//  MapDemo
//
//  Created by ssj on 2016/6/29.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Park.h"

@interface ParkMapViewController : UIViewController <MKMapViewDelegate>

typedef enum {
    MapTypeStandard = 0,
    MapTypeHybrid,
    MapTypeSatellite
} MapType;

@property (nonatomic, strong) Park *park;

@end

