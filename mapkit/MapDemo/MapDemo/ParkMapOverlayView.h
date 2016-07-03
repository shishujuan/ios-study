//
//  ParkMapOverlayView.h
//  MapDemo
//
//  Created by ssj on 2016/6/29.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface ParkMapOverlayView : MKOverlayPathRenderer

@property (strong, nonatomic) UIImage *overlayImage;

- (instancetype)initWithOverlayImage:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage;

@end
