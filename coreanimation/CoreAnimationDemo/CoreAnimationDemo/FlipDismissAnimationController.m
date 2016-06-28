//
//  FlipDismissAnimationController.m
//  CoreAnimationDemo
//
//  Created by ssj on 2016/6/28.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "FlipDismissAnimationController.h"
#import "RevealViewController.h"
#import "CardViewController.h"
#import "AnimationHelper.h"


@implementation FlipDismissAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    CardViewController *fromVC = (CardViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewKey];
    UIView *containerView = [transitionContext containerView];
    RevealViewController *toVC = (RevealViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewKey];
    
    
    BOOL hasViewForKey = [transitionContext respondsToSelector:@selector(viewForKey:)];
    
    UIView *fromView = hasViewForKey ? [transitionContext viewForKey:UITransitionContextFromViewKey] : fromVC.view;
    UIView *toView = hasViewForKey ? [transitionContext viewForKey:UITransitionContextToViewKey] : toVC.view;
        
    CGRect initialFrame = fromView.frame;
    CGRect finalFrame = self.destinationFrame;
    
    UIView *snapshot = [fromView snapshotViewAfterScreenUpdates:YES];
    snapshot.frame = initialFrame;
    snapshot.layer.cornerRadius = 25;
    snapshot.layer.masksToBounds = YES;
    
    [containerView addSubview:toView];
    [containerView addSubview:snapshot];
    fromView.hidden = YES;
    
    [AnimationHelper persipectiveTransformForContainerView:containerView];
    toView.layer.transform = [AnimationHelper yRotation:-M_PI_2];
    
    CGFloat duration = [self transitionDuration:transitionContext];
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0/3 animations:^{
            snapshot.frame = finalFrame;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:1.0/3 relativeDuration:1.0/3 animations:^{
            snapshot.layer.transform = [AnimationHelper yRotation:M_PI_2];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:2.0/3 relativeDuration:1.0/3 animations:^{
            toView.layer.transform = [AnimationHelper yRotation:0.0];
        }];
    } completion:^(BOOL finished){
        fromView.hidden = NO;
        [snapshot removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }
    ];
    
}

@end
