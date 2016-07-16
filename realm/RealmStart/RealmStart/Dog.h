//
//  Dog.h
//  RealmStart
//
//  Created by ssj on 2016/7/16.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <Realm/Realm.h>

@interface Dog : RLMObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, readonly) RLMLinkingObjects *owners;

@end

RLM_ARRAY_TYPE(Dog)
