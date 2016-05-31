//
//  FeedViewController.m
//  TableViewDemo
//
//  Created by ssj on 16/5/30.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "FeedViewController.h"
#import "ImageCell.h"
#import "BasicCell.h"
#import "MediaRSSParser.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"


@interface FeedViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
@property (strong, nonatomic) NSArray<RSSItem *> *items;

@end

@implementation FeedViewController 

static NSString *basicCellIdentifier = @"BasicCell";
static NSString *imageCellIdentifier = @"ImageCell";
static NSString *deviantArtBaseStringUrlString = @"http://backend.deviantart.com/rss.xml";



- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    [self refreshData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)configureTableView {
    self.feedTableView.rowHeight = UITableViewAutomaticDimension;
    self.feedTableView.estimatedRowHeight = 160.0;
    self.feedTableView.delegate = self;
    self.feedTableView.dataSource = self;
    self.searchTextField.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (IBAction)refresh:(id)sender {
    [self refreshData];
}

- (void)refreshData {
    [self.searchTextField resignFirstResponder];
    [self parseForQuery:self.searchTextField.text];
}

- (void)parseForQuery:(NSString *)query {
    [self showProgressHUD];
    RSSParser *parser = [[RSSParser alloc] init];
    [parser parseRSSFeed:deviantArtBaseStringUrlString parameters:[self parametersForQuery:query] success:^(RSSChannel *channel) {
        [self convertItemPropertiesToPlainText:channel.items];
        self.items = channel.items;
        [self hideProgressHUD];
        [self reloadTableViewContent];
    } failure:^(NSError *error) {
        [self hideProgressHUD];
        NSLog(@"Error:%@", error);
    }];
}

- (NSDictionary *)parametersForQuery:(NSString *)query {
    if (query != nil && query.length > 0) {
        return [NSDictionary dictionaryWithObjectsAndKeys:query, @"q", nil];
    } else {
        return [NSDictionary dictionaryWithObjectsAndKeys:@"boost:popular", @"q", nil];
    }
}

- (void)showProgressHUD {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    hud.labelText = @"Loading";

}

- (void)hideProgressHUD {
    [MBProgressHUD hideHUDForView:self.view animated:true];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self deselectAllRows];
}

- (void)deselectAllRows {
    NSArray<NSIndexPath *> *selectedRows = [self.feedTableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in selectedRows) {
        [self.feedTableView deselectRowAtIndexPath:indexPath animated:false];
    }
}

- (void)convertItemPropertiesToPlainText:(NSArray<RSSItem *> *)rssItems {
    for (RSSItem *item in rssItems) {
        NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        if (item.title) {
            item.title = [[item.title stringByConvertingHTMLToPlainText] stringByTrimmingCharactersInSet:charSet];
        }
        
        if (item.mediaDescription) {
            item.mediaDescription = [[item.mediaDescription stringByConvertingHTMLToPlainText] stringByTrimmingCharactersInSet:charSet];
        }
        
        if (item.mediaText) {
            item.mediaText = [[item.mediaText stringByConvertingHTMLToPlainText] stringByTrimmingCharactersInSet:charSet];
        }
    }
}

- (void)reloadTableViewContent {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.feedTableView reloadData];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self hasImageAtIndexPath:indexPath]) {
        return [self imageCellAtIndexPath:indexPath];
    } else {
        return [self basicCellAtIndexPath:indexPath];
    }
}

- (BOOL)hasImageAtIndexPath:(NSIndexPath *)indexPath {
    RSSItem *item = self.items[indexPath.row];
    NSArray<RSSMediaThumbnail *> *mediaThumbnailArray = [item mediaThumbnails];
    
    for (RSSMediaThumbnail *mediaThumbnail in mediaThumbnailArray) {
        if (mediaThumbnail.url != nil) {
            return YES;
        }
    }
    return NO;
}

- (ImageCell *)imageCellAtIndexPath:(NSIndexPath *)indexPath {
    ImageCell *cell = [self.feedTableView dequeueReusableCellWithIdentifier:imageCellIdentifier];
    [self setImageForCell:cell indexPath:indexPath];
    [self setTitleForCell:cell indexPath:indexPath];
    [self setSubtitleForCell:cell indexPath:indexPath];
    return cell;
}

- (void)setTitleForCell:(BasicCell *)cell indexPath:(NSIndexPath *)indexPath {
    RSSItem *item = self.items[indexPath.row];
    cell.titleLabel.text = item.title ? item.title : @"[No Title]";
}

- (void)setSubtitleForCell:(BasicCell *)cell indexPath:(NSIndexPath *)indexPath {
    RSSItem *item = self.items[indexPath.row];
    NSString *subTitleText = item.mediaText ? item.mediaText : item.mediaDescription;
    if (subTitleText) {
        subTitleText = subTitleText.length > 200 ? [subTitleText substringToIndex:200] : subTitleText;
    } else {
        subTitleText = @"";
    }
    cell.subtitleLabel.text = subTitleText;
}

- (void)setImageForCell:(ImageCell *)cell indexPath:(NSIndexPath *)indexPath {
    RSSItem *item = self.items[indexPath.row];
    RSSMediaThumbnail *mediaThumbnail;
    if (item.mediaThumbnails.count >= 2) {
        mediaThumbnail = item.mediaThumbnails[1];
    } else {
        mediaThumbnail = item.mediaThumbnails[0];
    }
    cell.customImageView.image = nil;
    if (mediaThumbnail.url != nil) {
        [cell.customImageView setImageWithURL:mediaThumbnail.url];
    }
}

- (BasicCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath {
    BasicCell *cell = [self.feedTableView dequeueReusableCellWithIdentifier:basicCellIdentifier];
    [self setTitleForCell:cell indexPath:indexPath];
    [self setSubtitleForCell:cell indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([self isLandscapeOrientation]) {
        return [self hasImageAtIndexPath:indexPath] ? 144.0: 120.0;
    } else {
        return [self hasImageAtIndexPath:indexPath] ? 235.0: 155.0;
    }
}

- (BOOL)isLandscapeOrientation {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self refreshData];
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[DetailViewController class]]) {
        NSIndexPath *indexPath = [self.feedTableView indexPathForSelectedRow];
        RSSItem *item = self.items[indexPath.row];
        DetailViewController *detailViewController = (DetailViewController *)segue.destinationViewController;
        detailViewController.item = item;
    }
}

@end
