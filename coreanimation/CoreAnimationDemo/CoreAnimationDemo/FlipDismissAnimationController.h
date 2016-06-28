//
//  FlipDismissAnimationController.h
//  CoreAnimationDemo
//
//  Created by ssj on 2016/6/28.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FlipDismissAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) CGRect destinationFrame;

@end
