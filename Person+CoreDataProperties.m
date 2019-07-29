//
//  Person+CoreDataProperties.m
//  HMCoreData
//
//  Created by humiao on 2019/7/29.
//  Copyright © 2019 humiao. All rights reserved.
//
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Person"];
}

@dynamic name;
@dynamic gander;
@dynamic age;
@dynamic height;
@dynamic weight;

@end
