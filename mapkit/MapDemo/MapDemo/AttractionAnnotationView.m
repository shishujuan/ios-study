//
//  AttractionAnnotationView.m
//  MapDemo
//
//  Created by ssj on 2016/6/30.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "AttractionAnnotationView.h"
#import "AttractionAnnotation.h"

@implementation AttractionAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([annotation isKindOfClass:[AttractionAnnotation class]]) {
            AttractionAnnotation *attractionAnnotation = (AttractionAnnotation *)annotation;
            switch (attractionAnnotation.type) {
                case AttractionFirstAd:
                    self.image = [UIImage imageNamed:@"firstaid"];
                    break;
                case AttractionFood:
                    self.image = [UIImage imageNamed:@"food"];
                    break;
                case AttractionRide:
                    self.image = [UIImage imageNamed:@"ride"];
                    break;
                default:
                    self.image = [UIImage imageNamed:@"star"];
                    break;
            }
        }
    }
   
    return self;
}

@end
