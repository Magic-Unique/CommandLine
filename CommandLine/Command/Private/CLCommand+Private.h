//
//  CLCommand+Private.h
//  CommandLineDemo
//
//  Created by Magic-Unique on 2019/2/4.
//  Copyright © 2023 Magic-Unique. All rights reserved.
//

#import "CLCommand.h"

@class CLRunner;

@interface CLCommand (Private)

- (void)__handleRunner:(CLRunner *)runner;

+ (NSString *)__name;

+ (NSString *)__note;

+ (CLCommandConfiguration *)__configuration;

+ (void)__configuration:(CLCommandConfiguration *)configuration;

@end
