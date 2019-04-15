//
//  CLRequest.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLRequest.h"
#import "CLCommand+Request.h"
#import "CLRequest+Private.h"
#import "CLFlag.h"
#import "CLIOPath.h"
#import "CCText.h"

@implementation CLRequest

- (instancetype)initWithCommands:(NSArray *)commands queries:(NSDictionary *)queries flags:(id)flags paths:(NSArray *)paths {
    self = [super init];
    if (self) {
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
        return [[self alloc] initWithCommands:commands queries:queries flags:flags paths:paths];
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
        CLRequest *returnValue = [[self alloc] initWithCommands:commands queries:nil flags:nil paths:nil];
        returnValue->_error = error;
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

@end

FOUNDATION_EXTERN void CLVerbose(NSString * _Nonnull format, ...) {
    if ([CLRequest verbose]) {
        va_list args;
        va_start(args, format);
        NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
        str = [str stringByAppendingString:@"\n"];
        va_end(args);
        printf("%s", str.UTF8String);
    }
}

FOUNDATION_EXTERN void CLInfo(NSString * _Nonnull format, ...) {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    str = [str stringByAppendingString:@"\n"];
    va_end(args);
    CCPrintf(CCStyleLight, str);
}

FOUNDATION_EXTERN void CLSuccess(NSString * _Nonnull format, ...) {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    str = [str stringByAppendingString:@"\n"];
    va_end(args);
    CCPrintf(CCStyleForegroundColorGreen, str);
    
}

FOUNDATION_EXTERN void CLWarning(NSString * _Nonnull format, ...) {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    str = [str stringByAppendingString:@"\n"];
    va_end(args);
    CCPrintf(CCStyleForegroundColorYellow, str);
}

FOUNDATION_EXTERN void CLError(NSString * _Nonnull format, ...) {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    str = [str stringByAppendingString:@"\n"];
    va_end(args);
    CCPrintf(CCStyleForegroundColorDarkRed, str);
}

void CLLog(NSString * _Nonnull format, ...) {
#if DEBUG == 1
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    str = [str stringByAppendingString:@"\n"];
    va_end(args);
    CCPrintf(0, str);
#endif
}
