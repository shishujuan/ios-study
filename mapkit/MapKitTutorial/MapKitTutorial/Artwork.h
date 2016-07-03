//
//  Artwork.h
//  MapKitTutorial
//
//  Created by ssj on 2016/7/3.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface Artwork : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *discipline;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (instancetype)init:(NSString *)title locationName:(NSString *)locationName discipline:(NSString *)discipline coordinate:(CLLocationCoordinate2D)coordinate;

- (MKMapItem *)mapItem;

+ (Artwork *)fromJSON:(NSArray *)json;

- (UIColor *) pinColor;

@end
