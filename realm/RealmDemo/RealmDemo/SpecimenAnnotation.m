//
//  SpecimenAnnotation.m
//  RealmDemo
//
//  Created by ssj on 2016/7/13.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "SpecimenAnnotation.h"

@implementation SpecimenAnnotation

- (instancetype)init:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle specimen:(Specimen *)specimen{
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.title = title;
        self.subtitle = subtitle;
        self.specimen = specimen;
    }
    return self;
}

@end
