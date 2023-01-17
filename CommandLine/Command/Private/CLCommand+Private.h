//
//  CLCommand+Private.h
//  CommandLineDemo
//
//  Created by Magic-Unique on 2019/2/4.
//  Copyright © 2023 Magic-Unique. All rights reserved.
//

#import "CLCommand.h"

@interface CLCommand (Private)

+ (NSString *)__name;

+ (NSString *)__note;

+ (CLCommandConfiguration *)__configuration;

+ (void)__configuration:(CLCommandConfiguration *)configuration;

@end
