//
//  ParkMapOverlayView.m
//  MapDemo
//
//  Created by ssj on 2016/6/29.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "ParkMapOverlayView.h"

@implementation ParkMapOverlayView

- (instancetype)initWithOverlayImage:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage {
    self = [super initWithOverlay:overlay];
    if (self) {
       self.overlayImage = overlayImage;
    }
    return self;
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    CGImageRef imageReference = self.overlayImage.CGImage;
    MKMapRect theMapRect = self.overlay.boundingMapRect;
    CGRect theRect = [self rectForMapRect:theMapRect];
    CGRect errorRect = CGRectMake(theMapRect.origin.x, theMapRect.origin.y, theMapRect.size.width, theMapRect.size.height);
    NSLog(@"overlay drawmaprect:%@, errorRect:%@", NSStringFromCGRect(theRect), NSStringFromCGRect(errorRect));
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -theRect.size.height);
    CGContextDrawImage(context, theRect, imageReference);
}



@end
