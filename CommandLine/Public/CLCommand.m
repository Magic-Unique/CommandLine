//
//  CLCommand.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLCommand.h"
#import "CLResponse+Private.h"
#import "CLCommand+Handler.h"

#define SharedCommand ((CLCommand *)[self main])
#define CLDefaultExplain(cmd) [NSString stringWithFormat:@"Call %@.explain = @\"Value you want.\" to change this line", cmd]

static NSString *CLCommandVersion = nil;

@interface CLCommand ()
{
    NSMutableDictionary<NSString *, CLCommand *> *_mSubcommands;
    NSMutableDictionary<NSString *, CLQuery *> *_mQueries;
    NSMutableDictionary<NSString *, CLFlag *> *_mFlags;
    NSMutableArray<CLIOPath *> *_mRequirePath;
    NSMutableArray<CLIOPath *> *_mOptionalPath;
}

@property (nonatomic, strong, readonly) NSMutableDictionary *mSubcommands;
@property (nonatomic, strong, readonly) NSMutableDictionary *mQueries;
@property (nonatomic, strong, readonly) NSMutableDictionary *mFlags;
@property (nonatomic, strong, readonly) NSMutableArray *mRequirePath;
@property (nonatomic, strong, readonly) NSMutableArray *mOptionalPath;

@end

@implementation CLCommand

+ (instancetype)main {
    static CLCommand *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        _sharedInstance->_command = [NSProcessInfo processInfo].arguments.firstObject.lastPathComponent;
        NSAssert(_sharedInstance.command, @"command is nil");
        _sharedInstance.explain = CLDefaultExplain(@"[CLCommand main]");
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        CLFlag *help = [CLFlag help];
        CLFlag *verbose = [CLFlag verbose];
        self.mFlags[help.key] = help;
        self.mFlags[verbose.key] = verbose;
    }
    return self;
}

- (NSArray<CLCommand *> *)commandNodes {
    CLCommand *command = self;
    NSMutableArray *nodes = [NSMutableArray arrayWithObject:command];
    while (command.supercommand) {
        command = command.supercommand;
        [nodes insertObject:command atIndex:0];
    }
    return [nodes copy];
}

- (NSArray<NSString *> *)commandPath {
    CLCommand *command = self;
    NSMutableArray *path = [NSMutableArray arrayWithObject:command.command];
    while (command.supercommand) {
        command = command.supercommand;
        [path insertObject:command.command atIndex:0];
    }
    return [path copy];
}

- (instancetype)defineSubcommand:(NSString *)command {
    CLCommand *subdefine = [self mSubcommands][command];
    if (!subdefine) {
        subdefine = [[[self class] alloc] init];
        subdefine->_command = command;
        subdefine->_supercommand = self;
        [self mSubcommands][command] = subdefine;
    }
    subdefine->_explain = CLDefaultExplain(command);
    return subdefine;
}

- (void)onHandlerRequest:(CLCommandTask)onHandler {
    _task = [onHandler copy];
}

+ (void)setVersion:(NSString *)version {
    CLCommandVersion = version;
    if (version.length) {
        SharedCommand.mFlags[@"version"] = [CLFlag version];
    } else {
        [SharedCommand.mFlags removeObjectForKey:@"version"];
    }
}

+ (NSString *)version {
    return CLCommandVersion;
}

- (NSDictionary<NSString *,CLCommand *> *)subcommands {
    return [_mSubcommands copy];
}

- (NSDictionary<NSString *,CLQuery *> *)queries {
    return [_mQueries copy];
}

- (NSDictionary<NSString *,CLFlag *> *)flags {
    return [_mFlags copy];
}

- (NSArray *)ioPaths {
    if (_mRequirePath.count + _mOptionalPath.count == 0) {
        return nil;
    } else {
        NSMutableArray *array = [NSMutableArray array];
        [array addObjectsFromArray:_mRequirePath];
        [array addObjectsFromArray:_mOptionalPath];
        return array.copy;
    }
}

- (CLQuery *(^)(NSString *))setQuery {
    return ^CLQuery *(NSString *key) {
        CLQuery *query = [[CLQuery alloc] initWithKey:key];
        self.mQueries[key] = query;
        return query;
    };
}

- (CLFlag *(^)(NSString *))setFlag {
    return ^CLFlag *(NSString *key) {
        CLFlag *flag = [[CLFlag alloc] initWithKey:key];
        self.mFlags[key] = flag;
        return flag;
    };
}

- (CLIOPath *(^)(NSString *))addRequirePath {
    return ^(NSString *key) {
        CLIOPath *path = [[CLIOPath alloc] initWithKey:key require:YES];
        [self.mRequirePath addObject:path];
        return path;
    };
}

- (CLIOPath *(^)(NSString *))addOptionalPath {
    return ^(NSString *key) {
        CLIOPath *path = [[CLIOPath alloc] initWithKey:key require:NO];
        [self.mOptionalPath addObject:path];
        return path;
    };
}

+ (CLResponse *)handleRequest:(CLRequest *)request {
    if (request.command) {
        return [request.command _handleRequest:request];
    } else {
        return [CLResponse responseWithUnrecognizedCommands:request.commands];
    }
}

- (NSMutableDictionary *)mSubcommands {
    if (!_mSubcommands) {
        _mSubcommands = [NSMutableDictionary dictionary];
    }
    return _mSubcommands;
}

- (NSMutableDictionary *)mQueries {
    if (!_mQueries) {
        _mQueries = [NSMutableDictionary dictionary];
    }
    return _mQueries;
}

- (NSMutableDictionary *)mFlags {
    if (!_mFlags) {
        _mFlags = [NSMutableDictionary dictionary];
    }
    return _mFlags;
}

- (NSMutableArray *)mRequirePath {
    if (!_mRequirePath) {
        _mRequirePath = [NSMutableArray array];
    }
    return _mRequirePath;
}

- (NSMutableArray *)mOptionalPath {
    if (!_mOptionalPath) {
        _mOptionalPath = [NSMutableArray array];
    }
    return _mOptionalPath;
}

- (NSString *)description {
    NSMutableString *output = [NSMutableString string];
    [output appendFormat:@"<Command\n"];
    [output appendFormat:@"\tCOMMAND: %@\n", self.command];
    if (_mQueries.count) {
        [output appendString:@"\tQUERIES:\n"];
        [[_mQueries.allValues sortedArrayUsingComparator:^NSComparisonResult(CLQuery *obj1, CLQuery *obj2) {
            if (obj1.isOptional == YES && obj2.isOptional == NO) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
        }] enumerateObjectsUsingBlock:^(CLQuery *obj, NSUInteger idx, BOOL *stop) {
            [output appendFormat:@"\t\t%@\n", obj];
        }];
    }
    if (_mFlags.count) {
        [output appendString:@"\tFLAGS:\n"];
        [_mFlags.allValues enumerateObjectsUsingBlock:^(CLFlag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [output appendFormat:@"\t\t%@\n", obj];
        }];
    }
    if (_mRequirePath.count + _mOptionalPath.count) {
        [output appendString:@"\tPATH:\n"];
        [_mRequirePath enumerateObjectsUsingBlock:^(CLIOPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [output appendFormat:@"\t\t%@\n", obj];
        }];
        [_mOptionalPath enumerateObjectsUsingBlock:^(CLIOPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [output appendFormat:@"\t\t%@\n", obj];
        }];
    }
    if (_mSubcommands.count) {
        [output appendString:@"\tSUBCOMMANDS:\n"];
        [_mSubcommands enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CLCommand * _Nonnull obj, BOOL * _Nonnull stop) {
            NSArray *lines = [obj.description componentsSeparatedByString:@"\n"];
            for (NSString *line in lines) {
                [output appendFormat:@"\t\t%@\n", line];
            }
        }];
    }
    [output appendString:@">"];
    return [output copy];
}

- (NSString *)title {
    return [NSString stringWithFormat:@"+ %@", self.command];
}

- (NSString *)subtitle {
    return self.explain?:@"";
}

@end
