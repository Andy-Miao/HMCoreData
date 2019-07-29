//
//  AppDelegate.h
//  HMCoreData
//
//  Created by humiao on 2019/7/29.
//  Copyright © 2019 humiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext:(NSString *)msg;


@end

