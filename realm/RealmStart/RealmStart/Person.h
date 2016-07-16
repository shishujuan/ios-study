//
//  Person.h
//  RealmStart
//
//  Created by ssj on 2016/7/16.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <Realm/Realm.h>
#import "Company.h"
#import "Dog.h"

@interface Person : RLMObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger age;
@property (nonatomic, strong) Company *company;
@property (nonatomic, strong) RLMArray<Dog *><Dog> *dogs;

@end
