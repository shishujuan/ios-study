//
//  Company.h
//  RealmStart
//
//  Created by ssj on 2016/7/16.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <Realm/Realm.h>

@interface Company : RLMObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic) NSInteger age;

@end
