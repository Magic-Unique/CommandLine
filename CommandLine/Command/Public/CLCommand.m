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
#import "CLLanguage.h"
#import "CLCommand+Process.h"
#import "CLExplain+Private.h"
#import <objc/runtime.h>

#import "CLCommand+Parser.h"
#import "CLProcess.h"

#define CLDefaultExplain(cmd)   [NSString stringWithFormat:CLCurrentLanguage[CLHelpCommandDefaultExplainKey], cmd]

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
@property (nonatomic, strong, readonly) NSMutableDictionary *mPredefineFlags;
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
        _sharedInstance.mPredefineFlags[[CLFlag help].key] = [CLFlag help];
        _sharedInstance.mPredefineFlags[[CLFlag verbose].key] = [CLFlag verbose];
        _sharedInstance.mPredefineFlags[[CLFlag silent].key] = [CLFlag silent];
        _sharedInstance.mPredefineFlags[[CLFlag noANSI].key] = [CLFlag noANSI];
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

+ (int)process {
    return [CLCommand _process:[CLProcess currentProcess]];
}

- (instancetype)initWithName:(NSString *)name supercommand:(CLCommand *)supercommand {
    self = [super init];
    if (self) {
        _mSubcommands = [NSMutableDictionary dictionary];
        _mQueries = [NSMutableDictionary dictionary];
        _mFlags = [NSMutableDictionary dictionary];
        _mPredefineFlags = [NSMutableDictionary dictionary];
        _mRequirePath = [NSMutableArray array];
        _mOptionalPath = [NSMutableArray array];
        
        _name = [name copy];
        _explain = CLDefaultExplain(name);
        _supercommand = supercommand;
        _allowInvalidKeys = supercommand.allowInvalidKeys;
        
        if (supercommand) {
            _commandPath = ({
                NSMutableArray *array = [supercommand.commandPath mutableCopy];
                [array addObject:name];
                [array copy];
            });
            [self _inheritFromSupercommand];
        } else {
            _commandPath = @[name];
        }
    }
    return self;
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
    
    for (CLFlag *superFlag in [supercommand.mPredefineFlags.allValues copy]) {
        if (superFlag.isInheritable) {
            self.mPredefineFlags[superFlag.key] = superFlag;
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

- (void)handleProcess:(CLCommandTask)handler {
    _task = [handler copy];
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

- (void)setVersion:(NSString *)version {
    _version = version;
    CLFlag *flag = [CLFlag version];
    if (version.length) {
        self.mPredefineFlags[flag.key] = flag;
    } else {
        [self.mPredefineFlags removeObjectForKey:flag.key];
    }
}

- (NSDictionary<NSString *,CLCommand *> *)subcommands {
    return [_mSubcommands copy];
}

- (NSDictionary<NSString *,CLQuery *> *)queries {
    return [_mQueries copy];
}

- (NSDictionary<NSString *,CLFlag *> *)flags {
    NSMutableDictionary *flags = [NSMutableDictionary dictionary];
    [flags addEntriesFromDictionary:_mFlags];
    [flags addEntriesFromDictionary:_mPredefineFlags];
    return [flags copy];
}

- (NSDictionary<NSString *,CLFlag *> *)customFlags {
    return [_mFlags copy];
}

- (NSDictionary<NSString *,CLFlag *> *)predefineFlags {
    return [_mPredefineFlags copy];
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
