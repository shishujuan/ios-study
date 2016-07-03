//
//  ParkMapOverlay.m
//  MapDemo
//
//  Created by ssj on 2016/6/29.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "ParkMapOverlay.h"
#import "Park.h"

@implementation ParkMapOverlay

- (instancetype)initWithPark:(Park *)park {
    self = [super init];
    if (self) {
        self.boundingMapRect = park.overlayBoundingMapRect;
        self.coordinate = park.midCoordinate;
    }
    return self;
}


@end
