//
//  AttractionAnnotation.m
//  MapDemo
//
//  Created by ssj on 2016/6/30.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "AttractionAnnotation.h"

@implementation AttractionAnnotation

- (instancetype)init:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle type:(AttractionType)type {
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.title = title;
        self.subtitle = subtitle;
        self.type = type;
    }
    return self;
}

@end
