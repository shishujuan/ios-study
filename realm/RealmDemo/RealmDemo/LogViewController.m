//
//  LogViewController.m
//  RealmDemo
//
//  Created by ssj on 2016/7/13.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "LogViewController.h"
#import "LogCell.h"
#import "Realm.h"
#import "Specimen.h"
#import "AddNewEntryController.h"

@interface LogViewController ()
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) RLMResults *searchResults;
@property (strong, nonatomic) RLMResults *specimens;
@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.specimens = [[Specimen allObjects] sortedResultsUsingProperty:@"name" ascending:YES];
    self.searchResults = [Specimen allObjects];
    [self addSearchController];
}

/**
 添加搜索栏。
 */
- (void)addSearchController {
    UITableViewController *searchResultsController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    searchResultsController.tableView.delegate = self;
    searchResultsController.tableView.dataSource = self;
    searchResultsController.tableView.rowHeight = 63;
    [searchResultsController.tableView registerClass:LogCell.self forCellReuseIdentifier:@"LogCell"];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    
    //这个选项用于设置在点击搜索框的时候是否隐藏导航栏，如果设置为NO，则不隐藏导航栏，默认隐藏。
    //self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    //这个选项设置搜索的时候是否暗化前一个View，NO为不暗化，默认为YES，前一个View会被暗化且不可点击。
    //self.searchController.dimsBackgroundDuringPresentation = NO;
    
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.tintColor = [UIColor whiteColor];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.scopeButtonTitles = @[@"A-Z", @"Created"];
    
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    //设置这个选项保证在搜索的时候点击结果时会隐藏搜索栏并转向另外一个视图。
    //默认为NO，UISearchController激活时点击搜索结果不会隐藏搜索栏。
    self.definesPresentationContext = YES;
}

/**
 旋转屏幕的时候调整搜索框的尺寸。
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.searchController.searchBar sizeToFit];
    } completion:nil];
}

- (void)filterResults:(NSInteger)scopeIndex {
    switch (scopeIndex) {
        case 0:
            self.searchResults = [self.searchResults sortedResultsUsingProperty:@"name" ascending:YES];
            break;
        case 1:
        default:
            self.searchResults = [self.searchResults sortedResultsUsingProperty:@"created" ascending:YES];
            break;
    }
    UITableViewController *searchResultsController = (UITableViewController *)self.searchController.searchResultsController;
    [searchResultsController.tableView reloadData];
}

- (void)searchResults:(UISearchBar *)searchBar {
    NSString *searchString = searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH %@", searchString.lowercaseString];
    self.searchResults = [Specimen objectsWithPredicate:predicate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [self.searchController.view removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self filterResults:searchBar.selectedScopeButtonIndex];
}

# pragma UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if ([searchController.searchResultsController isKindOfClass:[UITableViewController class]]) {
        [self searchResults:searchController.searchBar];
        [self filterResults:searchController.searchBar.selectedScopeButtonIndex];
    }
}

# pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchController.active ? self.searchResults.count: self.specimens.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Specimen *specimen = self.searchController.active ? self.searchResults[indexPath.row] : self.specimens[indexPath.row];

    LogCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LogCell"];
    cell.titleLabel.text = specimen.name;
    cell.subtitleLabel.text = specimen.category.name;
    NSString *iconName = [NSString stringWithFormat:@"Icon%@", specimen.category.name];
    cell.iconImageView.image = [UIImage imageNamed:iconName];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Edit"] && [segue.destinationViewController isKindOfClass:[AddNewEntryController class]]) {
        AddNewEntryController *addNewEntryController = (AddNewEntryController *)segue.destinationViewController;
        Specimen *selectedSpecimen = nil;
        
        if (self.searchController.active) {
            UITableViewController *searchResultsController = (UITableViewController *)self.searchController.searchResultsController;
            NSIndexPath *indexPathSearch = searchResultsController.tableView.indexPathForSelectedRow;
            selectedSpecimen = self.searchResults[indexPathSearch.row];
        } else {
            selectedSpecimen = self.specimens[self.tableView.indexPathForSelectedRow.row];
        }
        addNewEntryController.specimen = selectedSpecimen;
    }
}

@end