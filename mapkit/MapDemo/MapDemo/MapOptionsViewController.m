//
//  MapOptionsViewController.m
//  MapDemo
//
//  Created by ssj on 2016/6/29.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "MapOptionsViewController.h"

@interface MapOptionsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MapOptionsViewController

static NSString *cellIdentifier = @"OptionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSInteger mapOptionsType = indexPath.row;
    switch (mapOptionsType) {
        case MapOptionsTypeBoundary:
            cell.textLabel.text = @"Park Boundary";
            break;
        case MapOptionsTypeOverlay:
            cell.textLabel.text = @"Map Overlay";
            break;
        case MapOptionsTypePins:
            cell.textLabel.text = @"Attraction Pins";
            break;
        case MapOptionsTypeCharacterLocation:
            cell.textLabel.text = @"Character Location";
            break;
        case MapOptionsTypeRoute:
            cell.textLabel.text = @"Route";
            break;
        default:
            break;
    }
    if ([self.selectedOptions containsObject: [NSNumber numberWithInteger:mapOptionsType]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger mapOptionType = indexPath.row;
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedOptions removeObject:[NSNumber numberWithInteger:mapOptionType]];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedOptions addObject:[NSNumber numberWithInteger:mapOptionType]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
