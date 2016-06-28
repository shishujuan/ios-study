//
//  AnimationHelper.m
//  CoreAnimationDemo
//
//  Created by ssj on 2016/6/26.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "AnimationHelper.h"

@implementation AnimationHelper

+ (CATransform3D)yRotation:(CGFloat)angle {
    return CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
}

+ (void)persipectiveTransformForContainerView:(UIView *)containerView {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 1.0 / 500;
    containerView.layer.sublayerTransform = transform;
}

@end
