//
//  AnimationHelper.h
//  CoreAnimationDemo
//
//  Created by ssj on 2016/6/26.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AnimationHelper : NSObject

+ (CATransform3D)yRotation:(CGFloat)angle;
+ (void)persipectiveTransformForContainerView:(UIView *)containerView;


@end
