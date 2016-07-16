//
//  Specimen.m
//  RealmDemo
//
//  Created by ssj on 2016/7/14.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "Specimen.h"

@implementation Specimen

- (instancetype)initWithName:(NSString *)name specimenDescription:(NSString *)specimenDescription latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    self = [super init];
    if (self) {
        self.name = name;
        self.specimenDescription = specimenDescription;
        self.latitude = latitude;
        self.longitude = longitude;
        self.created = [NSDate date];
    }
    return self;
}


+ (NSArray *)indexedProperties {
    return @[@"name"];
}


@end
