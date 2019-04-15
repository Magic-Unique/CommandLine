//
//  CLResponse+Private.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/21.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLResponse+Private.h"
#import "NSError+CommandLine.h"

@implementation CLResponse (Private)

+ (instancetype)responseWithHelpCommands:(NSArray *)commands {
    return [self succeed:@{@"commands":commands}];
}

+ (instancetype)responseWithMissingArguments:(NSArray *)arguments {
    NSString *args = [arguments componentsJoinedByString:@","];
    NSString *print = [NSString stringWithFormat:@"Missing require arguments: %@.", args];
    return [self error:CLErrorWithPrintInformation(CLMissingRequireQueriesError, print)];
}

+ (instancetype)responseWithMissingPathsCount:(NSUInteger)count {
    NSString *print = [NSString stringWithFormat:@"Missing path, require %lu path for this command.", count];
    return [self error:CLErrorWithPrintInformation(CLMissingPathsError, print)];
}

@end
