//
//  AttractionAnnotation.h
//  MapDemo
//
//  Created by ssj on 2016/6/30.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AttractionAnnotation : NSObject <MKAnnotation>

typedef enum {
    AttractionDefault = 0,
    AttractionRide,
    AttractionFood,
    AttractionFirstAd
} AttractionType;

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) AttractionType type;

- (instancetype)init:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle type:(AttractionType)type;

@end
