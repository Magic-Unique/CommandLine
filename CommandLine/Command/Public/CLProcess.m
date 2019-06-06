//
//  CLProcess.m
//  CommandLine
//
//  Created by Magic-Unique on 2019/4/28.
//

#import "CLProcess.h"
#import "CLCommand+Parser.h"
#import "CLFlag.h"
#import "CLIOPath.h"
#import <CommandLine/ANSI.h>

@implementation CLProcess

+ (instancetype)currentProcess {
    static CLProcess *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *arguments = [NSProcessInfo.processInfo.arguments mutableCopy];
        CLCommand *command = [CLCommand commandWithArguments:arguments];
        _shared = [command processWithCommands:command.commandPath arguments:arguments];
    });
    return _shared;
}

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

- (instancetype)initWithCommands:(NSArray *)commands queries:(NSDictionary *)queries flags:(id)flags paths:(NSArray *)paths error:(NSError *)error {
    self = [self initWithCommands:commands queries:queries flags:flags paths:paths];
    if (self) {
        _error = error;
    }
    return self;
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

- (void)exit:(int)code {
    exit(code);
}

@end

void CLExit(int code) {
    [[CLProcess currentProcess] exit:code];
}
