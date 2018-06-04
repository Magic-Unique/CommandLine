//
//  CLResponse+Private.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/21.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLResponse+Private.h"

@implementation CLResponse (Private)

+ (instancetype)responseWithHelpCommands:(NSArray *)commands {
    return [self succeed:@{@"commands":commands}];
}

+ (instancetype)responseWithUnrecognizedCommands:(NSArray *)commands {
    return [self errorWithDescription:[NSString stringWithFormat:@"Unrecognized command: %@.", [commands componentsJoinedByString:@" "]]];
}

+ (instancetype)responseWithMissingArguments:(NSArray *)arguments {
    return [self errorWithDescription:[NSString stringWithFormat:@"Missing require arguments: %@.", [arguments componentsJoinedByString:@","]]];
}

+ (instancetype)responseWithMissingPathsCount:(NSUInteger)count {
    return [self errorWithDescription:[NSString stringWithFormat:@"Missing path, require %lu path for this command.", count]];;
}

+ (instancetype)responseWithUndefinedTaskCommands:(NSArray *)commands {
    return [self errorWithDescription:[NSString stringWithFormat:@"Undefined task for command: %@.", [commands componentsJoinedByString:@" "]]];
}

@end
