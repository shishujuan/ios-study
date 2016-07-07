//
//  ViewController.m
//  CoreDataTutorial
//
//  Created by ssj on 2016/7/4.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<NSManagedObject *> *people;
@property (strong, nonatomic) NSManagedObjectContext *privateContext;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self loadData];
    [self loadDataInPrivateContext];
}

- (NSManagedObjectContext *)privateContext {
    if (!_privateContext) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
        
        _privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _privateContext.parentContext = managedObjectContext;
    }
    return _privateContext;
}

- (void)loadData {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext = appDelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    NSError *error;
    NSArray<NSManagedObject *> *results = [managedContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"fetch error, %@, info:%@", error, error.userInfo);
        return;
    }
    self.people = [results mutableCopy];
}

- (void)loadDataInPrivateContext {
    NSLog(@"pid:%d, tid:%@", getpid(), [NSThread currentThread]);
    [self.privateContext performBlock:^{
        NSLog(@"pid in private:%d, tid:%@", getpid(), [NSThread currentThread]);
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
        NSArray<NSManagedObject *> *results = [self.privateContext executeFetchRequest:fetchRequest error:nil];
        self.people = [results mutableCopy];
        //sleep(10);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"pid in main queue:%d, tid:%@", getpid(), [NSThread currentThread]);
            [self.tableView reloadData];
        });
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)people {
    if (!_people) {
        _people = [[NSMutableArray alloc] init];
    }
    return _people;
}

- (IBAction)addName:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Name" message:@"Add a new name" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields.firstObject;
        [self saveName:textField.text];
        [self.tableView reloadData];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (void)saveName:(NSString *)name {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext = appDelegate.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:managedContext];
    NSManagedObject *person = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedContext];
    [person setValue:name forKey:@"name"];
    [appDelegate saveContext];
    [self.people addObject:person];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.people count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSManagedObject *person = self.people[indexPath.row];
    cell.textLabel.text = [person valueForKey:@"name"];
    return cell;
}



@end
