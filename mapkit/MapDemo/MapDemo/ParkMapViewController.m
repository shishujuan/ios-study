//
//  ViewController.m
//  MapDemo
//
//  Created by ssj on 2016/6/29.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "ParkMapViewController.h"
#import "MapOptionsViewController.h"
#import "ParkMapOverlayView.h"
#import "ParkMapOverlay.h"
#import "AttractionAnnotation.h"
#import "AttractionAnnotationView.h"
#import "Character.h"

@interface ParkMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentedControl;
@property (strong, nonatomic) NSMutableArray *selectedOptions;
@end

@implementation ParkMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedOptions = [[NSMutableArray alloc] init];

    self.park = [[Park alloc] initWithFileName:@"MagicMountain"];
    
    CLLocationDegrees latDelta = self.park.overlayTopLeftCoordinate.latitude -
    self.park.overlayBottomRightCoordinate.latitude;
    
    CLLocationDegrees lonDelta = self.park.overlayTopLeftCoordinate.longitude - self.park.overlayBottomRightCoordinate.longitude;
    
    // think of a span as a tv size, measure from one corner to another
    MKCoordinateSpan span = MKCoordinateSpanMake(fabs(latDelta), fabs(lonDelta));
        
    MKCoordinateRegion region = MKCoordinateRegionMake(self.park.midCoordinate, span);
    self.mapView.region = region;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[MapOptionsViewController class]]) {
        MapOptionsViewController *mapOptionsViewController = (MapOptionsViewController *)segue.destinationViewController;
        mapOptionsViewController.selectedOptions = self.selectedOptions;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)mapTypeChanged:(id)sender {
    NSInteger mapType = self.mapTypeSegmentedControl.selectedSegmentIndex;
    switch (mapType) {
        case MapTypeStandard:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case MapTypeHybrid:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case MapTypeSatellite:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
    }
}

- (void)addOverlay {
    ParkMapOverlay *overlay = [[ParkMapOverlay alloc] initWithPark:self.park];
    [self.mapView addOverlay:overlay level:MKOverlayLevelAboveLabels];
}

- (void)addAttractionPins {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MagicMountainAttractions" ofType:@"plist"];
    NSArray<NSDictionary *> *attractions = [NSArray arrayWithContentsOfFile:filePath];
    
    for (NSDictionary *attraction in attractions) {
        CGPoint point = CGPointFromString(attraction[@"location"]);
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(point.x, point.y);
        NSString *title = attraction[@"name"];
        NSString *subtitle = attraction[@"subtitle"];
        NSString *typeRaw = attraction[@"type"];
        AttractionType type = [typeRaw intValue];
        AttractionAnnotation *annotation = [[AttractionAnnotation alloc] init:coordinate title:title subtitle:subtitle type:type];
        [self.mapView addAnnotation:annotation];
    }
}

- (void)addRoute {
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"EntranceToGoliathRoute" ofType:@"plist"];
    NSArray *pointsArray = [NSArray arrayWithContentsOfFile:thePath];
    CLLocationCoordinate2D coordinates[pointsArray.count];
    for (int i = 0; i < pointsArray.count; i++) {
        CGPoint point = CGPointFromString(pointsArray[i]);
        coordinates[i] = CLLocationCoordinate2DMake(point.x, point.y);
    }
    MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:coordinates count:pointsArray.count];
    [self.mapView addOverlay:myPolyline];
}

- (void)addBoundary {
    CLLocationCoordinate2D coordinates[self.park.boundaryPointsCount];
    for (int i = 0; i < self.park.boundaryPointsCount; i++) {
        NSValue *value = self.park.boundary[i];
        coordinates[i] = value.MKCoordinateValue;
    }
    MKPolygon *polygon = [MKPolygon polygonWithCoordinates:coordinates count:self.park.boundaryPointsCount];
    [self.mapView addOverlay:polygon];
}

- (void)addCharacterLocation {
    NSArray *resourceNameArray = @[@"BatmanLocations", @"TazLocations", @"TweetyBirdLocations"];
    NSArray *circleColors = @[[UIColor blueColor], [UIColor orangeColor], [UIColor yellowColor]];
    for (NSString *resourceName in resourceNameArray) {
        NSString *resourceFilePath = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"plist"];
        NSArray *resourceLocations = [NSArray arrayWithContentsOfFile:resourceFilePath];
        CGPoint resourcePoint = CGPointFromString(resourceLocations[rand() % 4]);
        CLLocationCoordinate2D resourceCenterCoordinate = CLLocationCoordinate2DMake(resourcePoint.x, resourcePoint.y);
        CLLocationDistance resourceRadius = fmax(5, rand() % 40);
        Character *character = [Character circleWithCenterCoordinate:resourceCenterCoordinate radius:resourceRadius];
        
        NSInteger index = [resourceNameArray indexOfObject:resourceName];
        character.color = circleColors[index];
        [self.mapView addOverlay:character];
    }
}

- (void)loadSelectedOptions {
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    
    for (NSNumber *option in self.selectedOptions) {
        switch ([option integerValue]) {
            case MapOptionsTypeOverlay:
                [self addOverlay];
                break;
            case MapOptionsTypePins:
                [self addAttractionPins];
                break;
            case MapOptionsTypeRoute:
                [self addRoute];
                break;
            case MapOptionsTypeBoundary:
                [self addBoundary];
                break;
            case MapOptionsTypeCharacterLocation:
                [self addCharacterLocation];
                break;
            default:
                break;
        }
    }
}

- (IBAction)closeOptions:(UIStoryboardSegue *)segue {
    UIViewController *sourceViewController = segue.sourceViewController;
    if ([sourceViewController isKindOfClass:[MapOptionsViewController class]]) {
        MapOptionsViewController *optionViewController = (MapOptionsViewController *)sourceViewController;
        self.selectedOptions = optionViewController.selectedOptions;
        [self loadSelectedOptions];
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    NSLog(@"render");
    if ([overlay isKindOfClass:[ParkMapOverlay class]]) {
        UIImage *magicMoutainImage = [UIImage imageNamed:@"overlay_park"];
        ParkMapOverlayView *overlayView = [[ParkMapOverlayView alloc] initWithOverlayImage:overlay overlayImage:magicMoutainImage];
        return overlayView;
    } else if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        lineView.strokeColor = [UIColor greenColor];
        return lineView;
    } else if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygonRenderer *polygonView = [[MKPolygonRenderer alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [UIColor magentaColor];
        return polygonView;
    } else if ([overlay isKindOfClass:[Character class]]) {
        MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circleView.strokeColor = ((Character *)overlay).color;
        return circleView;
    }
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[AttractionAnnotation class]]) {
        AttractionAnnotationView *annotationView = [[AttractionAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Attraction"];
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    return nil;
}


@end
