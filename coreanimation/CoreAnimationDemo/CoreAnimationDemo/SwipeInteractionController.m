//
//  SwipeInteractionController.m
//  CoreAnimationDemo
//
//  Created by ssj on 2016/6/28.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "SwipeInteractionController.h"

@implementation SwipeInteractionController

- (void)wireToViewController:(UIViewController *)viewController {
    self.viewController = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}

- (void)prepareGestureRecognizerInView:(UIView *)view {
    UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action: @selector(handleGesture:)];
    gesture.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:gesture];
}

- (void)handleGesture:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    // 1
    CGFloat progress = (translation.x / 200);
    NSLog(@"gesture view=%@, gesture.superview=%@, point=%@", gestureRecognizer.view, gestureRecognizer.view.superview, NSStringFromCGPoint(translation));
    progress = fminf(fmaxf(progress, 0.0), 1.0);
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.interactionInProgress = YES;
            [self.viewController dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged:
            self.shouldCompleteTransition = progress > 0.5;
            [self updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateCancelled:
            self.interactionInProgress = NO;
            [self cancelInteractiveTransition];
            break;
        case UIGestureRecognizerStateEnded:
            self.interactionInProgress = NO;
            if (!self.shouldCompleteTransition) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
        default:
            NSLog(@"Unsupported");
            break;
    }
}



@end
