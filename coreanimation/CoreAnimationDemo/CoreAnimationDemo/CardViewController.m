//
//  ViewController.m
//  CoreAnimationDemo
//
//  Created by ssj on 16/6/23.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "CardViewController.h"
#import "RevealViewController.h"
#import "FlipPresentAnimationController.h"
#import "FlipDismissAnimationController.h"
#import "SwipeInteractionController.h"

@interface CardViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (strong, nonatomic) FlipPresentAnimationController *flipPresentAnimationController;
@property (strong, nonatomic) FlipDismissAnimationController *flipDismissAnimationController;
@property (strong, nonatomic) SwipeInteractionController *swipeInteractionControllers;


@end

static NSString *revealSegueId = @"revealSegue";

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.petCard.desc;
    self.cardView.layer.cornerRadius = 25;
    self.cardView.layer.masksToBounds = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.cardView addGestureRecognizer:gesture];
    self.flipPresentAnimationController = [[FlipPresentAnimationController alloc] init];
    self.flipDismissAnimationController = [[FlipDismissAnimationController alloc] init];
    self.swipeInteractionControllers = [[SwipeInteractionController alloc] init];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    [self performSegueWithIdentifier:revealSegueId sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:revealSegueId] && [segue.destinationViewController isKindOfClass:[RevealViewController class]]) {
        RevealViewController *revealViewController = (RevealViewController *)segue.destinationViewController;
        revealViewController.petCard = self.petCard;
        revealViewController.transitioningDelegate = self;
        [self.swipeInteractionControllers wireToViewController:revealViewController];
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.flipPresentAnimationController.originFrame = self.cardView.frame;
    return self.flipPresentAnimationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.flipDismissAnimationController.destinationFrame = self.cardView.frame;
    return self.flipDismissAnimationController;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.swipeInteractionControllers.interactionInProgress ? self.swipeInteractionControllers : nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
