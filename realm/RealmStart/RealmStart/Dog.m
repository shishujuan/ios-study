//
//  Dog.m
//  RealmStart
//
//  Created by ssj on 2016/7/16.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "Dog.h"
#import "Person.h"

@implementation Dog

+ (NSDictionary *)linkingObjectsProperties {
    return @{
        @"owners": [RLMPropertyDescriptor descriptorWithClass:Person.class propertyName:@"dogs"],
    };
}

@end
