//
//  Specimen.h
//  RealmDemo
//
//  Created by ssj on 2016/7/14.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Realm.h"
#import "Category.h"

@interface Specimen : RLMObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *specimenDescription;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) Category *category;

- (instancetype)initWithName:(NSString *)name specimenDescription:(NSString *)specimenDescription latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

@end
