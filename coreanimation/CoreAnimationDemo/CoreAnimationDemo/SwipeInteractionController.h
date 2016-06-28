//
//  SwipeInteractionController.h
//  CoreAnimationDemo
//
//  Created by ssj on 2016/6/28.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwipeInteractionController : UIPercentDrivenInteractiveTransition

@property (nonatomic) BOOL interactionInProgress;
@property (nonatomic) BOOL shouldCompleteTransition;
@property (nonatomic, strong) UIViewController *viewController;

- (void)wireToViewController:(UIViewController *)viewController;

@end
