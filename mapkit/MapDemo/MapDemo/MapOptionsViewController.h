//
//  MapOptionsViewController.h
//  MapDemo
//
//  Created by ssj on 2016/6/29.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapOptionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

typedef enum {
    MapOptionsTypeBoundary = 0,
    MapOptionsTypeOverlay,
    MapOptionsTypePins,
    MapOptionsTypeCharacterLocation,
    MapOptionsTypeRoute
} MapOptionsType;

@property (strong, nonatomic) NSMutableArray *selectedOptions;

@end
