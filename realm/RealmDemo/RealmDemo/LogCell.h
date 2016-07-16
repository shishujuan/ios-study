//
//  LogCellTableViewCell.h
//  RealmDemo
//
//  Created by ssj on 2016/7/13.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end