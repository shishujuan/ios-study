//
//  Character.h
//  MapDemo
//
//  Created by ssj on 2016/6/30.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface Character : MKCircle <MKOverlay>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIColor *color;

@end
