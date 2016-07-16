//
//  AppDelegate.m
//  RealmStart
//
//  Created by ssj on 2016/7/16.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "AppDelegate.h"
#import "Realm.h"
#import "Person.h"
#import "Company.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)cleanRealm {
    NSFileManager *manager = [NSFileManager defaultManager];
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    NSArray<NSURL *> *realmFileURLs = @[
                                        config.fileURL,
                                        [config.fileURL URLByAppendingPathExtension:@"lock"],
                                        [config.fileURL URLByAppendingPathExtension:@"management"],
                                        ];
    for (NSURL *URL in realmFileURLs) {
        NSError *error = nil;
        [manager removeItemAtURL:URL error:&error];
        if (error) {
            NSLog(@"clean realm error:%@", error);
        }
    }
}

- (void)addInitDataToRealm {
    Company *company = [[Company alloc] init];
    company.name = @"GOOGLE";
    
    Person *person = [[Person alloc] init];
    person.name = @"张三";
    person.age = 28;
    person.company = company;
    
    Dog *dog1 = [[Dog alloc] init];
    dog1.name = @"小黑";
    dog1.color = @"黑色";
    
    Dog *dog2 = [[Dog alloc] init];
    dog2.name = @"小狗子";
    dog2.color = @"黑色";
    
    
    Dog *dog3 = [[Dog alloc] init];
    dog3.name = @"大白";
    dog3.color = @"白色";
    
    [person.dogs addObject:dog1];
    [person.dogs addObject:dog2];
    [person.dogs addObject:dog3];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:person];
    }];
}

- (void)queryRealm {
    RLMResults<Dog *> *dogs = [[Dog objectsWhere:@"color = '黑色' AND name BEGINSWITH '小'"] 	sortedResultsUsingProperty:@"name" ascending:YES];
    for (Dog *dog in dogs) {
        NSLog(@"dog:%@， owners:%@", dog, dog.owners);
    }
}

- (void)updateRealm {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"color = %@ AND name BEGINSWITH %@", @"白色", @"大"];
    RLMResults *dogs = [Dog objectsWithPredicate:pred];
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        for (Dog *dog in dogs) {
            dog.color = @"新的颜色";
        }
    }];
}

- (void)multithreadRealm {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        NSLog(@"start async");
        RLMResults *results = [Person objectsWhere:@"name = '张三' "];
        if (results.count > 0) {
            Person *person = results[0];
            NSLog(@"outer block, name:%@", person.name);
        }
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            NSLog(@"in async block");
            RLMResults *results = [Person objectsWhere:@"name = '张三' "];
            if (results.count > 0) {
                Person *person = results[0];
                person.name = @"王麻子";
                NSLog(@"change name to wangmazi");
            }
        }];
        if (results.count > 0) {
            Person *person = results[0];
            NSLog(@"async person:%@, tid=%@", person.name, [NSThread currentThread]);
        }
    });
    
    NSArray *names = @[@"张三", @"李四"];
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        int i = 0;
        while (i < 2) {
            NSString *name = names[i];
            RLMResults *results = [Person objectsWhere:@"name = %@", name];
            if (results.count > 0) {
                Person *person = results[0];
                if ([person.name isEqualToString:@"李四"]) {
                    person.name = @"王五";
                    NSLog(@"change name to wangwu");
                } else {
                    person.name = @"李四";
                    NSLog(@"change name to lisi");
                }
                sleep(3);
            }
            i++;
        }
    }];
}

- (void)migrateRealm {
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.schemaVersion = 1;
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion){
        if (oldSchemaVersion < 1) {}
    };
    [RLMRealmConfiguration setDefaultConfiguration:config];
    [RLMRealm defaultRealm];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self cleanRealm];
    [self addInitDataToRealm];
    //[self migrateRealm];
    [self queryRealm];
    [self updateRealm];
    [self multithreadRealm];
    
    NSLog(@"db path:%@", [RLMRealm defaultRealm].configuration.fileURL);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
