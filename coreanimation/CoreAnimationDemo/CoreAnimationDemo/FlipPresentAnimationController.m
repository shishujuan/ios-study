//
//  FlipPresentAnimationController.m
//  CoreAnimationDemo
//
//  Created by ssj on 2016/6/26.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "FlipPresentAnimationController.h"
#import "RevealViewController.h"
#import "CardViewController.h"
#import "AnimationHelper.h"

@implementation FlipPresentAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 2.0;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    CardViewController *fromVC = (CardViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewKey];
    UIView *containerView = [transitionContext containerView];
    RevealViewController *toVC = (RevealViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewKey];
    
    
    BOOL hasViewForKey = [transitionContext respondsToSelector:@selector(viewForKey:)];
    
    UIView *fromView = hasViewForKey ? [transitionContext viewForKey:UITransitionContextFromViewKey] : fromVC.view;
    UIView *toView = hasViewForKey ? [transitionContext viewForKey:UITransitionContextToViewKey] : toVC.view;
    
    CGRect initialFrame = self.originFrame;    
    CGRect finalFrame = hasViewForKey? toView.frame : [transitionContext finalFrameForViewController:toVC];
    
    UIView *snapshot = [toView snapshotViewAfterScreenUpdates:YES];
    snapshot.frame = initialFrame;
    snapshot.layer.cornerRadius = 25;
    snapshot.layer.masksToBounds = YES;
    
    [containerView addSubview:toView];
    [containerView addSubview:snapshot];
    toView.hidden = YES;
    
    [AnimationHelper persipectiveTransformForContainerView:containerView];
    snapshot.layer.transform = [AnimationHelper yRotation:M_PI_2];
    
    CGFloat duration = [self transitionDuration:transitionContext];
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0/3 animations:^{
            fromView.layer.transform = [AnimationHelper yRotation:-M_PI_2];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:1.0/3 relativeDuration:1.0/3 animations:^{
            snapshot.layer.transform = [AnimationHelper yRotation:0.0];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:2.0/3 relativeDuration:1.0/3 animations:^{
            snapshot.frame = finalFrame;
        }];
        } completion:^(BOOL finished){
            toView.hidden = NO;
            fromView.layer.transform = [AnimationHelper yRotation:0.0];
            [snapshot removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }
     ];

}
@end
