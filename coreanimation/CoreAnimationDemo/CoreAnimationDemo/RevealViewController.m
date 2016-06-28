//
//  RevealViewController.m
//  CoreAnimationDemo
//
//  Created by ssj on 2016/6/26.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "RevealViewController.h"

@interface RevealViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation RevealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.petCard.name;
    self.imageView.image = self.petCard.image;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
