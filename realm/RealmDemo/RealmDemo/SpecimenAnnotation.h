//
//  SpecimenAnnotation.h
//  RealmDemo
//
//  Created by ssj on 2016/7/13.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Specimen.h"

@interface SpecimenAnnotation : NSObject <MKAnnotation>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) Specimen *specimen;

- (instancetype)init:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle specimen:(Specimen *)specimen;

@end
