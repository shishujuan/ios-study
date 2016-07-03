//
//  Artwork.m
//  MapKitTutorial
//
//  Created by ssj on 2016/7/3.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "Artwork.h"
#import <Contacts/Contacts.h>

@implementation Artwork

- (instancetype)init:(NSString *)title locationName:(NSString *)locationName discipline:(NSString *)discipline coordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self) {
        self.title = title;
        self.locationName = locationName;
        self.discipline = discipline;
        self.coordinate = coordinate;
    }
    return self;
}

- (NSString *)description {
    NSString *desc = [NSString stringWithFormat: @"title:%@, locationName:%@, discipline:%@, coordinate:%f,%f", self.title, self.locationName, self.discipline, self.coordinate.latitude, self.coordinate.longitude];
    return desc;
}

- (NSString *)subtitle {
    return self.locationName;
}

- (MKMapItem *)mapItem {
    NSDictionary *addressDictionary = @{CNPostalAddressStreetKey: self.locationName};
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:addressDictionary];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    return mapItem;
}

- (UIColor *) pinColor {
    UIColor __block *color;
    ((void (^)())@{
        @"Sculpture" : ^{
            color = [MKPinAnnotationView redPinColor];
        },
        @"Plaque" : ^{
            color = [MKPinAnnotationView redPinColor];
        },
        @"Mural" : ^{
            color = [MKPinAnnotationView purplePinColor];
        },
        @"Monument" : ^{
            color = [MKPinAnnotationView purplePinColor];
        },
    }[self.discipline] ?: ^{
        color = [MKPinAnnotationView greenPinColor];
    })();
    return color;
}

+ (Artwork *)fromJSON:(NSArray *)json {
    id title = json[16];
    if (title == [NSNull null]) {
        title = @"no title";
    }
    NSString *locationName = json[12];
    NSString *discipline = json[15];
    
    CLLocationDegrees latitude = [json[18] doubleValue];
    CLLocationDegrees longitude = [json[19] doubleValue];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    Artwork *artwork = [[Artwork alloc] init:title locationName:locationName discipline:discipline coordinate:coordinate];
    return artwork;
}


@end
