//
//  DetailViewController.m
//  TableViewDemo
//
//  Created by ssj on 16/5/30.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "DetailViewController.h"
#import "RSSMediaContent.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()

@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setImageViewImage];
    [self setTitleLabelText];
    [self setSubtitleLabelText];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImageViewImage {
    if (self.imageView == nil) return;
    
    NSURL *url = [self firstMediaContentImageURL];
    if (url == nil) return;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.activityIndicator startAnimating];
    
    [self.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [self.activityIndicator stopAnimating];
        self.imageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [self.activityIndicator stopAnimating];
        self.imageView.image = nil;
        NSLog(@"ImageRequest Error:%@", error);
    }];
}

- (NSURL *)firstMediaContentImageURL {
    if (self.item.mediaContents == nil) return nil;
    
    for (RSSMediaContent *mediaContent in self.item.mediaContents) {
        if (mediaContent.url != nil) {
            return mediaContent.url;
        }
    }
    return nil;
}

- (void)setTitleLabelText {
    NSString *title = self.item.title;
    if (title == nil || title.length == 0) {
        title = NSLocalizedString(@"[No Title]", comment: "");
    }
    self.titleLabel.text = title;
}

- (void)setSubtitleLabelText {
    NSString *subtitle = self.item.mediaText;
    if (subtitle == nil) {
        subtitle = self.item.mediaDescription ? self.item.mediaDescription : @"";
    }
    self.subtitleLabel.text = subtitle;
}

@end
