//
//  AddNewEntryViewController.m
//  RealmDemo
//
//  Created by ssj on 2016/7/13.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "AddNewEntryController.h"
#import "CategoriesTableViewController.h"
#import "Specimen.h"
#import "Realm.h"

@interface AddNewEntryController()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;
@property (strong, nonatomic) Category *selectedCategory;
@end

@implementation AddNewEntryController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.specimen) {
        self.title = [NSString stringWithFormat:@"Edit %@", self.specimen.name];
        [self fillTextFields];
    } else {
        self.title = @"Add New Specimen";
    }
}

/**
 检查输入项是否合法，不合法则弹出警告框。
 */
- (BOOL)validateFields {
    if (!self.nameTextField.text || !self.descriptionTextField.text || !self.selectedCategory) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Validation Error" message:@"All fields must be filled" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return NO;
    } else {
        return YES;
    }
}

/**
 从分类列表返回，设置分类文本输入框的内容为选择的分类。
 */
- (IBAction)unwindFromCategories:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"CategorySelectedSegue"] && [segue.sourceViewController isKindOfClass:[CategoriesTableViewController class]]) {
        CategoriesTableViewController *categoriesTableViewController = (CategoriesTableViewController *)segue.sourceViewController;
        self.selectedCategory = categoriesTableViewController.selectedCategory;
        self.categoryTextField.text = self.selectedCategory.name;
    }
}

/**
 点击Confirm返回上一个视图前，添加specimen到数据库。
 */
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (self.specimen != nil) {
        [self updateSpecimen];
        return YES;
    }
    
    if ([self validateFields]) {
        [self addNewSpecimen];
        return YES;
    } else {
        return NO;
    }
}

- (void)addNewSpecimen {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        Specimen *specimen = [[Specimen alloc] initWithName:self.nameTextField.text specimenDescription:self.descriptionTextField.text latitude:self.selectedAnnotation.coordinate.latitude longitude:self.selectedAnnotation.coordinate.longitude];
        specimen.category = self.selectedCategory;
        [realm addObject:specimen];
        self.specimen = specimen;
    }];
}

- (void)updateSpecimen {
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        self.specimen.name = self.nameTextField.text;
        self.specimen.category = self.selectedCategory;
        self.specimen.specimenDescription = self.descriptionTextField.text;
    }];
}

- (void)fillTextFields {
    self.nameTextField.text = self.specimen.name;
    self.categoryTextField.text = self.specimen.category.name;
    self.descriptionTextField.text = self.specimen.specimenDescription;
    self.selectedCategory = self.specimen.category;
}

#pragma UITextFieldDelegate
/**
 点击类别文本框，弹出类别列表视图。
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self performSegueWithIdentifier:@"Categories" sender:self];
}

@end
