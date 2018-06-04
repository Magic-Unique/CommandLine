//
//  CLRequest.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLRequest.h"
#import "CLCommand+Request.h"
#import "CLIOPath.h"

@implementation CLRequest

+ (instancetype)request {
    return [self requestWithProcessProcess:[NSProcessInfo processInfo]];
}

+ (instancetype)requestWithProcessProcess:(NSProcessInfo *)processInfo {
    return [self requestWithArguments:processInfo.arguments];
}

+ (instancetype)requestWithArgc:(int)argc argv:(const char *[])argv {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:argc];
    for (NSUInteger i = 0; i < argc; i++) {
        NSString *item = [NSString stringWithUTF8String:argv[i]];
        [array addObject:item];
    }
    return [self requestWithArguments:array];
}

+ (instancetype)requestWithArguments:(NSArray *)arguments {
    return [CLCommand requestWithArguments:arguments];
}

- (instancetype)initWithCommand:(CLCommand *)command Commands:(NSArray *)commands queries:(NSDictionary *)queries flags:(id)flags paths:(NSArray *)paths {
//    NSLog(@"Command: %@", command.command);
//    NSLog(@"Commands: %@", commands);
//    NSLog(@"queries: %@", queries);
//    NSLog(@"flags: %@", flags);
//    NSLog(@"paths: %@", paths);
    self = [super init];
    if (self) {
        _command = command;
        _commands = commands;
        _queries = queries;
        _paths = paths;
        if ([flags isKindOfClass:[NSSet class]]) {
            _flags = flags;
        } else if ([flags isKindOfClass:[NSArray class]]) {
            _flags = [NSSet setWithArray:flags];
        } else {
            _flags = nil;
        }
    }
    return self;
}

+ (instancetype)requestWithCommands:(NSArray *)commands queries:(NSDictionary *)queries flags:(id)flags paths:(NSArray *)paths {
    NSMutableArray *_cmds = [commands mutableCopy];
    CLCommand *command = [CLCommand sharedCommand];
    while (_cmds.count > 1) {
        command = command.subcommands[_cmds[1]];
        [_cmds removeObjectAtIndex:1];
        if (command == nil) {
            break;
        }
    }
    if (command) {
        return [[self alloc] initWithCommand:command Commands:commands queries:queries flags:flags paths:paths];
    } else {
        return nil;
    }
}

- (NSString *)stringForQuery:(NSString *)query {
    return self.queries[query];
}

- (NSString *)pathForQuery:(NSString *)query {
    return [CLIOPath abslutePath:self.queries[query]];
}

- (NSInteger)integerValueForQuery:(NSString *)query {
    NSString *value = self.queries[query];
    return [value integerValue];
}

- (void)verbose:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    if ([self.flags containsObject:[CLFlag verbose].key]) {
        printf("%s", str.UTF8String);
    }
}

@end
