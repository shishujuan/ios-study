//
//  ViewController.h
//  CoreAnimationDemo
//
//  Created by ssj on 16/6/23.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PetCard.h"

@interface CardViewController : UIViewController <UIViewControllerTransitioningDelegate>

@property (nonatomic) NSInteger pageIndex;
@property (nonatomic, strong) PetCard *petCard;

@end

