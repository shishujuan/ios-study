//
//  ParkMapOverlay.h
//  MapDemo
//
//  Created by ssj on 2016/6/29.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Park.h"

@interface ParkMapOverlay : NSObject <MKOverlay>

@property (nonatomic) MKMapRect boundingMapRect;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (instancetype)initWithPark:(Park *)park;

@end
