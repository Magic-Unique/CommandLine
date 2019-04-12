//
//  CLCommand.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLCommand.h"
#import "CLQuery.h"
#import "CLFlag.h"
#import "CLIOPath.h"
#import "CLRequest.h"
#import "CLResponse.h"
#import "CLResponse+Private.h"
#import "CLCommand+Handler.h"
#import "CLExplain+Private.h"
#import <objc/runtime.h>

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
@property (nonatomic, assign, readonly) BOOL isForwardingTarget;

@end

@implementation CLCommand

+ (instancetype)mainCommand {
    static CLCommand *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *executableName = [NSProcessInfo processInfo].arguments.firstObject.lastPathComponent;
        _sharedInstance = [[self alloc] initWithName:executableName supercommand:nil];
        NSAssert(_sharedInstance.name, @"command is nil");
        _sharedInstance.mFlags[[CLFlag help].key] = [CLFlag help];
        _sharedInstance.mFlags[[CLFlag verbose].key] = [CLFlag verbose];
        _sharedInstance.explain = CLDefaultExplain(@"[CLCommand main]");
    });
    return _sharedInstance;
}

+ (instancetype)main {
    return [self mainCommand];
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

- (instancetype)initWithName:(NSString *)name supercommand:(CLCommand *)supercommand {
    self = [super init];
    if (self) {
        _mSubcommands = [NSMutableDictionary dictionary];
        _mQueries = [NSMutableDictionary dictionary];
        _mFlags = [NSMutableDictionary dictionary];
        _mRequirePath = [NSMutableArray array];
        _mOptionalPath = [NSMutableArray array];
        
        _name = [name copy];
        _explain = CLDefaultExplain(name);
        _supercommand = supercommand;
        _allowInvalidKeys = supercommand.allowInvalidKeys;
        
        if (supercommand) {
            [self _inheritFromSupercommand];
        }
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
    NSMutableArray *path = [NSMutableArray arrayWithObject:command.name];
    while (command.supercommand) {
        command = command.supercommand;
        [path insertObject:command.name atIndex:0];
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

- (instancetype)defineForwardingSubcommand:(NSString *)command {
    if (_forwardingSubcommand) {
        if (![_forwardingSubcommand.name isEqualToString:command]) {
            NSAssert(NO, @"The command `%@` already contains default subcommand `%@`", self.name, self.forwardingSubcommand.name);
        } else {
            return _forwardingSubcommand;
        }
    }
    CLCommand *subdefine = [self defineSubcommand:command];
    if (!_forwardingSubcommand) {
        subdefine->_isForwardingTarget = YES;
        _forwardingSubcommand = subdefine;
    }
    return subdefine;
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
        [CLCommand mainCommand].mFlags[@"version"] = [CLFlag version];
    } else {
        [[CLCommand mainCommand].mFlags removeObjectForKey:@"version"];
    }
}

+ (CLResponse *)handleRequest:(CLRequest *)request {
    if (request.command) {
        return [request.command _handleRequest:request];
    } else {
        return [CLResponse responseWithUnrecognizedCommands:request.commands];
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

- (NSArray *)IOPaths {
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

- (NSString *)title {
    if (self.isForwardingTarget) {
        return [NSString stringWithFormat:@"> %@", self.name];
    } else {
        return [NSString stringWithFormat:@"+ %@", self.name];
    }
}

- (NSString *)subtitle {
    return self.explain?:@"";
}

@end
