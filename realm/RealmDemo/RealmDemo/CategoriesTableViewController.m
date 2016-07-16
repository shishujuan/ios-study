//
//  CategoriesTableViewController.m
//  RealmDemo
//
//  Created by ssj on 2016/7/13.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "CategoriesTableViewController.h"
#import "Category.h"
#import "Realm.h"

@interface CategoriesTableViewController ()

@property (nonatomic, strong) RLMResults *categories;
@property (nonatomic, strong) RLMRealm *realm;

@end

@implementation CategoriesTableViewController

- (RLMRealm *)realm {
    if (!_realm) {
        _realm = [RLMRealm defaultRealm];
    }
    return _realm;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (RLMResults *)categories {
    _categories = [Category allObjects];
    if (_categories.count == 0) {
        [self.realm beginWriteTransaction];
        NSArray *defaultCategories = @[@"Bird", @"Mammal", @"Flora", @"Reptile", @"Arachnid"];
        for (NSString *category in defaultCategories) {
            Category *newCategory = [[Category alloc] init];
            newCategory.name = category;
            [self.realm addObject:newCategory];
        }
        [self.realm commitWriteTransaction];
        _categories = [Category allObjects];
    }
    return _categories;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell" forIndexPath:indexPath];
    Category *category = self.categories[indexPath.row];
    cell.textLabel.text = category.name;
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCategory = self.categories[indexPath.row];
    return indexPath;
}

@end
