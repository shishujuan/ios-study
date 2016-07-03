//
//  Park.h
//  MapDemo
//
//  Created by ssj on 2016/6/29.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Park : NSObject

@property (nonatomic) NSMutableArray<NSValue *> *boundary;
@property (nonatomic) NSInteger boundaryPointsCount;
@property (nonatomic) CLLocationCoordinate2D midCoordinate;
@property (nonatomic) CLLocationCoordinate2D overlayTopLeftCoordinate;
@property (nonatomic) CLLocationCoordinate2D overlayTopRightCoordinate;
@property (nonatomic) CLLocationCoordinate2D overlayBottomLeftCoordinate;
@property (nonatomic) CLLocationCoordinate2D overlayBottomRightCoordinate;
@property (nonatomic, getter=getOverlayBoundingMapRect) MKMapRect overlayBoundingMapRect;
@property (nonatomic, strong) NSString *name;

- (instancetype)initWithFileName:(NSString *)filename;


@end
