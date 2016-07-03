//
//  ViewController.m
//  MapKitTutorial
//
//  Created by ssj on 7/1/16.
//  Copyright © 2016 ease. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "Artwork.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray<Artwork *> *artworks;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self centerMapOnLocation];
    [self addAnnotation];
    self.mapView.delegate = self;
    [self loadInitialData];
    [self.mapView addAnnotations:self.artworks];
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (NSMutableArray *)artworks {
    if (!_artworks) {
        _artworks = [[NSMutableArray alloc] init];
    }
    return _artworks;
}

- (void)addAnnotation {
    CLLocationCoordinate2D coordinate = {21.283921, -157.831661};
    Artwork *artwork = [[Artwork alloc] init: @"King David Kalakaua"
                          locationName: @"Waikiki Gateway Park"
                          discipline: @"Sculpture"
                          coordinate: coordinate];
    [self.mapView addAnnotation:artwork];
}

- (void)centerMapOnLocation {
    CLLocationCoordinate2D initialLocation = {21.282778, -157.829444};
    CLLocationDistance regionRadius = 1000;
    
    MKCoordinateRegion coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation, regionRadius * 2, regionRadius * 2);
    [self.mapView setRegion:coordinateRegion];
}

- (void)loadInitialData {
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"PublicArt" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:fileName];
    NSError *error;
    
    id rawJsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error == nil && [rawJsonObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *jsonObject = (NSDictionary *)rawJsonObject;
        NSArray *jsonData = jsonObject[@"data"];
        if (jsonData != nil) {
            for (NSArray *artworkJSON in jsonData) {
                Artwork *artwork = [Artwork fromJSON:artworkJSON];
                [self.artworks addObject:artwork];
            }
        }
    }
}

- (void)checkLocationStatus {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;
    } else {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkLocationStatus];
}

#pragma MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[Artwork class]]) {
        NSString *identifier = @"pin";
        MKPinAnnotationView *view = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!view) {
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            view.canShowCallout = YES;
            view.calloutOffset = CGPointMake(-10, 5);
            view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        
        //view.pinTintColor = [UIColor blueColor];
        
        Artwork *artwork = (Artwork *)annotation;
        view.pinTintColor = [artwork pinColor];
        return view;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    Artwork *artwork = (Artwork *)view.annotation;
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving};
    [[artwork mapItem] openInMapsWithLaunchOptions:launchOptions];
}


@end
