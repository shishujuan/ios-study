//
//  ViewController.m
//  RealmDemo
//
//  Created by ssj on 2016/7/13.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "MapViewController.h"
#import "SpecimenAnnotation.h"
#import "AddNewEntryController.h"
#import "Realm.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) SpecimenAnnotation *lastAnnotation;
@property (strong, nonatomic) RLMResults *specimens;
@end

@implementation MapViewController

static const CLLocationDistance MVCDistanceMeters = 500;
static NSString *MVCDefaultAnnotationIconName = @"IconUncategorized";

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLocation];
    [self populateMap];
    
    NSLog(@"db path:%@", [RLMRealm defaultRealm].configuration.fileURL);
}

- (void)populateMap {
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.specimens = [Specimen allObjects];
    
    for (Specimen *specimen in self.specimens) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(specimen.latitude, specimen.longitude);
        SpecimenAnnotation *specimenAnnotation = [[SpecimenAnnotation alloc] init:coordinate title:specimen.name subtitle:specimen.category.name specimen:specimen];
        [self.mapView addAnnotation:specimenAnnotation];
    }
}

- (void)startLocation {
    self.mapView.delegate = self;
    self.locationManager.delegate = self;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        [self.locationManager startUpdatingLocation];
    }
}


- (IBAction)addNewEntryTapped:(id)sender {
    if (self.lastAnnotation != nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Annotation already dropped" message:@"There is an annotation on screen, try dragging it if you want change its location!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        SpecimenAnnotation *specimenAnnotation = [[SpecimenAnnotation alloc] init:self.mapView.centerCoordinate title:@"Empty" subtitle:@"Uncategorized" specimen:nil];
        [self.mapView addAnnotation:specimenAnnotation];
        self.lastAnnotation = specimenAnnotation;
    }
}

- (IBAction)centerUserLocationTapped:(id)sender {
    CLLocationCoordinate2D center = self.mapView.userLocation.coordinate;
    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(center, MVCDistanceMeters, MVCDistanceMeters);
    [self.mapView setRegion:zoomRegion animated:YES];
}

- (IBAction)unwindFromAddNewEntry:(UIStoryboardSegue *)segue {
    UIViewController *sourceViewController = segue.sourceViewController;
    if ([sourceViewController isKindOfClass:[AddNewEntryController class]]) {
        AddNewEntryController *addNewEntryController = (AddNewEntryController *)sourceViewController;
        Specimen *addedSpecimen = addNewEntryController.specimen;
        CLLocationCoordinate2D addedSpecimenCoordinate = CLLocationCoordinate2DMake(addedSpecimen.latitude, addedSpecimen.longitude);
        
        if (self.lastAnnotation != nil) {
            [self.mapView removeAnnotation:self.lastAnnotation];
        } else {
            for (SpecimenAnnotation *annotation in self.mapView.annotations) {
                if (annotation.coordinate.latitude == addedSpecimenCoordinate.latitude && annotation.coordinate.longitude == addedSpecimenCoordinate.longitude) {
                    [self.mapView removeAnnotation:annotation];
                    break;
                }
            }
        }
        
        SpecimenAnnotation *annotation = [[SpecimenAnnotation alloc] init:addedSpecimenCoordinate title:addedSpecimen.name subtitle:addedSpecimen.category.name specimen:addedSpecimen];
        [self.mapView addAnnotation:annotation];
        self.lastAnnotation = nil;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewEntry"] && [segue.destinationViewController isKindOfClass:[AddNewEntryController class]]) {
        if ([sender isKindOfClass:[SpecimenAnnotation class]]) {
            SpecimenAnnotation *specimenAnnotation = (SpecimenAnnotation *)sender;
            AddNewEntryController *addNewEntryController = (AddNewEntryController *)segue.destinationViewController;
            addNewEntryController.selectedAnnotation = specimenAnnotation;
            addNewEntryController.specimen = specimenAnnotation.specimen;
        }
    }
}

#pragma CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;
    } else {
        NSLog(@"Authorization to use location data denied");
    }
}

#pragma MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[SpecimenAnnotation class]]) {
        SpecimenAnnotation *currentAnnotation = (SpecimenAnnotation *)annotation;
        NSString *subtitle = currentAnnotation.subtitle;
        MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:subtitle];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:subtitle];
            //自定义后需要设置canShowCallout为YES，不然点击不会显示信息。
            annotationView.canShowCallout = YES;
            //设置信息展示偏移
            annotationView.calloutOffset = CGPointMake(-10, 5);
            //设置信息按钮
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            NSString *iconName = [NSString stringWithFormat:@"Icon%@", subtitle];
            annotationView.image = [UIImage imageNamed:iconName];
            if (annotationView.image == nil) {
                annotationView.image = [UIImage imageNamed:MVCDefaultAnnotationIconName];
            }
            if ([subtitle isEqualToString:@"Uncategorized"]) {
                annotationView.draggable = YES;
            }
        }
        return annotationView;
    }
    return nil;
}

/**
 实现这个方法的目的是为了拖动停止后，你拖动地图时，这个标记会随着地图一起移动。
 如果不实现该方法，拖动地图时标记不会随着移动。
 */
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    if (newState == MKAnnotationViewDragStateEnding) {
        view.dragState = MKAnnotationViewDragStateNone;
    }
}

/**
 点击标记的信息按钮，跳转到添加标记视图。
 */
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if ([view.annotation isKindOfClass:[SpecimenAnnotation class]]) {
        SpecimenAnnotation *specimentAnnotation = (SpecimenAnnotation *)view.annotation;
        [self performSegueWithIdentifier:@"NewEntry" sender:specimentAnnotation];
    }
}

/**
 添加标记的动画，从上往下落下。
 */
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    for (MKAnnotationView *annotationView in views) {
        annotationView.transform = CGAffineTransformMakeTranslation(0, -500);
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            annotationView.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:nil];
    }
}

@end
