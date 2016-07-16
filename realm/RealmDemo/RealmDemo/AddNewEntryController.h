//
//  AddNewEntryViewController.h
//  RealmDemo
//
//  Created by ssj on 2016/7/13.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecimenAnnotation.h"

@interface AddNewEntryController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) SpecimenAnnotation *selectedAnnotation;
@property (strong, nonatomic) Specimen *specimen;

@end
