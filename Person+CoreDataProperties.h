//
//  Person+CoreDataProperties.h
//  HMCoreData
//
//  Created by humiao on 2019/7/29.
//  Copyright © 2019 humiao. All rights reserved.
//
//

#import "Person+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *gander;
@property (nonatomic) int16_t age;
@property (nonatomic) int16_t height;
@property (nonatomic) int16_t weight;

@end

NS_ASSUME_NONNULL_END
