//
//  Park.m
//  MapDemo
//
//  Created by ssj on 2016/6/29.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "Park.h"

@implementation Park

- (instancetype)initWithFileName:(NSString *)filename {
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
        NSDictionary *properties = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        CGPoint midPoint = CGPointFromString(properties[@"midCoord"]);
        self.midCoordinate = CLLocationCoordinate2DMake(midPoint.x, midPoint.y);
        
        CGPoint overlayTopLeftPoint = CGPointFromString(properties[@"overlayTopLeftCoord"]);
        self.overlayTopLeftCoordinate = CLLocationCoordinate2DMake(overlayTopLeftPoint.x, overlayTopLeftPoint.y);
        
        CGPoint overlayTopRightPoint = CGPointFromString(properties[@"overlayTopRightCoord"]);
        self.overlayTopRightCoordinate = CLLocationCoordinate2DMake(overlayTopRightPoint.x, overlayTopRightPoint.y);
        
        CGPoint overlayBottomLeftPoint = CGPointFromString(properties[@"overlayBottomLeftCoord"]);
        self.overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(overlayBottomLeftPoint.x, overlayBottomLeftPoint.y);
        
        self.overlayBottomRightCoordinate = CLLocationCoordinate2DMake(self.overlayBottomLeftCoordinate.latitude, self.overlayTopRightCoordinate.longitude);
        
        NSArray *boundaryPoints = (NSArray *)properties[@"boundary"];
        self.boundaryPointsCount = [boundaryPoints count];
        
        self.boundary = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.boundaryPointsCount; i++) {
            CGPoint point = CGPointFromString(boundaryPoints[i]);
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(point.x, point.y);
            NSValue *value = [NSValue valueWithMKCoordinate:coordinate];
            [self.boundary addObject:value];
        }
    }
    return self;
}

- (MKMapRect)getOverlayBoundingMapRect {
    MKMapPoint topLeft = MKMapPointForCoordinate(self.overlayTopLeftCoordinate);
    MKMapPoint topRight = MKMapPointForCoordinate(self.overlayTopRightCoordinate);
    MKMapPoint bottomLeft = MKMapPointForCoordinate(self.overlayBottomLeftCoordinate);
    
    NSLog(@"top left coord:%f, %f, mkpoint:%f, %f", self.overlayTopLeftCoordinate.latitude, self.overlayTopLeftCoordinate.longitude, topLeft.x, topLeft.y);
    return MKMapRectMake(topLeft.x,
                         topLeft.y,
                         fabs(topLeft.x-topRight.x),
                         fabs(topLeft.y - bottomLeft.y));
}


@end
