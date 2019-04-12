//
//  CLRequest.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLRequest.h"
#import "CLCommand+Request.h"
#import "CLFlag.h"
#import "CLIOPath.h"
#import "CCText.h"

@implementation CLRequest

+ (instancetype)request {
    return [self requestWithProcessProcess:[NSProcessInfo processInfo]];
}

+ (instancetype)requestWithProcessProcess:(NSProcessInfo *)processInfo {
    NSMutableArray *arguments = [processInfo.arguments mutableCopy];
    [arguments removeObjectAtIndex:0];
    return [self requestWithArguments:arguments];
}

+ (instancetype)requestWithArgc:(int)argc argv:(const char *[])argv {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:argc];
    for (NSUInteger i = 1; i < argc; i++) {
        NSString *item = [NSString stringWithUTF8String:argv[i]];
        [array addObject:item];
    }
    return [self requestWithArguments:array];
}

+ (instancetype)requestWithArguments:(NSArray *)arguments {
    arguments = ({
        NSMutableArray *arg = [NSMutableArray arrayWithArray:arguments];
        [arg insertObject:NSProcessInfo.processInfo.arguments.firstObject.lastPathComponent atIndex:0];
        [arg copy];
    });
    return [CLCommand requestWithArguments:arguments];
}

- (instancetype)initWithCommand:(CLCommand *)command Commands:(NSArray *)commands queries:(NSDictionary *)queries flags:(id)flags paths:(NSArray *)paths {
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
    CLCommand *command = [CLCommand mainCommand];
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

+ (instancetype)illegallyRequestWithCommands:(NSArray *)commands error:(NSError *)error {
    NSMutableArray *_cmds = [commands mutableCopy];
    CLCommand *command = [CLCommand mainCommand];
    while (_cmds.count > 1) {
        command = command.subcommands[_cmds[1]];
        [_cmds removeObjectAtIndex:1];
        if (command == nil) {
            break;
        }
    }
    if (command) {
        CLRequest *returnValue = [[self alloc] initWithCommand:command Commands:commands queries:nil flags:nil paths:nil];
        returnValue->_illegalError = error;
        return returnValue;
    } else {
        return nil;
    }
}

- (NSString *)stringForQuery:(NSString *)query {
    id value = self.queries[query];
    if ([value isKindOfClass:[NSArray class]]) {
        return [(NSArray *)value firstObject];
    } else {
        return value;
    }
}

- (NSString *)pathForQuery:(NSString *)query {
    return [CLIOPath abslutePath:[self stringForQuery:query]];
}

- (NSInteger)integerValueForQuery:(NSString *)query {
    NSString *value = [self stringForQuery:query];
    return [value integerValue];
}

- (BOOL)flag:(NSString *)flag {
    return [self.flags containsObject:flag];
}

- (NSString *)pathForIndex:(NSUInteger)index {
    if (index >= self.paths.count) {
        return nil;
    }
    return [CLIOPath abslutePath:self.paths[index]];
}

- (void)verbose:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    str = [str stringByAppendingString:@"\n"];
    va_end(args);
    if ([self flag:[CLFlag verbose].key]) {
        printf("%s", str.UTF8String);
    }
}

- (void)print:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    printf("%s", str.UTF8String);
}

- (void)error:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    str = [str stringByAppendingString:@"\n"];
    va_end(args);
    CCPrintf(CCStyleForegroundColorDarkRed, str);
}

- (void)warning:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    str = [str stringByAppendingString:@"\n"];
    va_end(args);
    CCPrintf(CCStyleForegroundColorYellow, str);
}

- (void)success:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    str = [str stringByAppendingString:@"\n"];
    va_end(args);
    CCPrintf(CCStyleForegroundColorGreen, str);
}

- (void)info:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    str = [str stringByAppendingString:@"\n"];
    va_end(args);
    CCPrintf(CCStyleLight, str);
}

@end
