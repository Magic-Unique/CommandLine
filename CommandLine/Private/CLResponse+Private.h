//
//  CLResponse+Private.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/21.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLResponse.h"

@interface CLResponse (Private)

+ (instancetype)responseWithHelpCommands:(NSArray *)commands;

+ (instancetype)responseWithUnrecognizedCommands:(NSArray *)commands;

+ (instancetype)responseWithMissingArguments:(NSArray *)arguments;

+ (instancetype)responseWithMissingPathsCount:(NSUInteger)count;

+ (instancetype)responseWithUndefinedTaskCommands:(NSArray *)commands;

@end
