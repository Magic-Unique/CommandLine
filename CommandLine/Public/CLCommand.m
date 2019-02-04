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
#import "CLExplain+Private.h"
#import <objc/runtime.h>

#define SharedCommand           ((CLCommand *)[self main])
#define CLDefaultExplain(cmd)   [NSString stringWithFormat:@"Call %@.explain = @\"Value you want.\" to change this line", cmd]

static NSString *CLCommandVersion = nil;

@interface CLCommand () <CLExplainDelegate>
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
        NSString *executableName = [NSProcessInfo processInfo].arguments.firstObject.lastPathComponent;
        _sharedInstance = [[self alloc] initWithName:executableName];
        NSAssert(_sharedInstance.command, @"command is nil");
        _sharedInstance.mFlags[[CLFlag help].key] = [CLFlag help];
        _sharedInstance.mFlags[[CLFlag verbose].key] = [CLFlag verbose];
        _sharedInstance.explain = CLDefaultExplain(@"[CLCommand main]");
    });
    return _sharedInstance;
}

+ (void)defineCommandsForClass:(NSString *)className metaSelectorPrefix:(NSString *)prefix {
    Class metaCls = objc_getMetaClass(className.UTF8String);
    Class cls = objc_getClass(className.UTF8String);
    if (metaCls && cls) {
        unsigned count = 0;
        Method *methodList = class_copyMethodList(metaCls, &count);
        for (unsigned i = 0; i < count; i++) {
            Method method = methodList[i];
            SEL sel = method_getName(method);
            NSString *name = NSStringFromSelector(sel);
            if ([name hasPrefix:prefix]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [cls performSelector:sel];
#pragma clang diagnostic pop
            }
        }
    }
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _command = [name copy];
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
        subdefine = [[[self class] alloc] initWithName:command supercommand:self];
        [self mSubcommands][command] = subdefine;
    }
    return subdefine;
}

- (instancetype)initWithName:(NSString *)name supercommand:(CLCommand *)supercommand {
    self = [self initWithName:name];
    if (self) {
        _explain = CLDefaultExplain(name);
        _supercommand = supercommand;
        _allowInvalidKeys = supercommand.allowInvalidKeys;
        [self _inheritFromSupercommand];
    }
    return self;
}

- (void)_inheritFromSupercommand {
    CLCommand *supercommand = _supercommand;
    
    for (CLQuery *superQuery in [supercommand.mQueries.allValues copy]) {
        if (superQuery.isInheritable) {
            self.mQueries[superQuery.key] = superQuery;
        }
    }
    
    for (CLFlag *superFlag in [supercommand.mFlags.allValues copy]) {
        if (superFlag.isInheritable) {
            self.mFlags[superFlag.key] = superFlag;
        }
    }
    
    for (CLIOPath *superPath in [supercommand.mRequirePath copy]) {
        if (superPath.isInheritable) {
            [self.mRequirePath addObject:superPath];
        }
    }
    
    for (CLIOPath *superPath in [supercommand.mOptionalPath copy]) {
        if (superPath.isInheritable) {
            [self.mOptionalPath addObject:superPath];
        }
    }
}

- (void)onHandlerRequest:(CLCommandTask)onHandler {
    _task = [onHandler copy];
}

- (void)explainDidInheritify:(CLExplain *)explain {
    for (CLCommand *subcommand in [self.mSubcommands copy]) {
        if ([explain isKindOfClass:[CLQuery class]]) {
            CLQuery *query = (CLQuery *)explain;
            subcommand.mQueries[query.key] = query;
        }
        else if ([explain isKindOfClass:[CLFlag class]]) {
            CLFlag *flag = (CLFlag *)explain;
            subcommand.mFlags[flag.key] = flag;
        }
        else if ([explain isKindOfClass:[CLIOPath class]]) {
            CLIOPath *path = (CLIOPath *)explain;
            NSMutableArray *paths = path.isRequire ? subcommand.mRequirePath : subcommand.mOptionalPath;
            [paths addObject:path];
        }
    }
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
        query.delegate = self;
        self.mQueries[key] = query;
        return query;
    };
}

- (CLFlag *(^)(NSString *))setFlag {
    return ^CLFlag *(NSString *key) {
        CLFlag *flag = [[CLFlag alloc] initWithKey:key];
        flag.delegate = self;
        self.mFlags[key] = flag;
        return flag;
    };
}

- (CLIOPath *(^)(NSString *))addRequirePath {
    return ^(NSString *key) {
        CLIOPath *path = [[CLIOPath alloc] initWithKey:key require:YES];
        path.delegate = self;
        [self.mRequirePath addObject:path];
        return path;
    };
}

- (CLIOPath *(^)(NSString *))addOptionalPath {
    return ^(NSString *key) {
        CLIOPath *path = [[CLIOPath alloc] initWithKey:key require:NO];
        path.delegate = self;
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
