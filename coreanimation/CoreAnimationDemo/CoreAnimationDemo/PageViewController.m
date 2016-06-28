//
//  PageViewController.m
//  CoreAnimationDemo
//
//  Created by ssj on 2016/6/26.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "PageViewController.h"
#import "CardViewController.h"
#import "PetCardStore.h"

@interface PageViewController()
@property (nonatomic, strong) NSArray *petCards;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.petCards = [PetCardStore defaultPets];
    UIViewController *initViewController = [self viewControllerAtIndex:0];
    [self setViewControllers:@[initViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CardViewController"];
    if ([viewController isKindOfClass:[CardViewController class]]) {
        CardViewController * cardViewController = (CardViewController *)viewController;
        cardViewController.pageIndex = index;
        cardViewController.petCard = self.petCards[index];
        return cardViewController;
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[CardViewController class]]) {
        CardViewController *cardViewController = (CardViewController *)viewController;
        NSInteger pageIndex = cardViewController.pageIndex;
        if (pageIndex > 0) {
            return [self viewControllerAtIndex:pageIndex-1];
        } else {
            return nil;
        }
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[CardViewController class]]) {
        CardViewController *cardViewController = (CardViewController *)viewController;
        NSInteger pageIndex = cardViewController.pageIndex;
        if (pageIndex < [self.petCards count] - 1) {
            return [self viewControllerAtIndex:pageIndex + 1];
        } else {
            return nil;
        }
    }
    return nil;

}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return [self.petCards count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

@end
