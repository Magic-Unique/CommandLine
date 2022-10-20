//
//  CLRunnableCommand.m
//  CommandLineDemo
//
//  Created by 吴双 on 2022/8/31.
//  Copyright © 2022 unique. All rights reserved.
//

#import "CLRunnableCommand.h"
#import <objc/runtime.h>

@implementation CLRunnableCommand

- (void)enumerateInstanceMethodUsingBlock:(void (^)(CLRunnableCommand *self, SEL selector, NSString *name))block {
    Class cls = [self class];
    if (cls) {
        unsigned count = 0;
        Method *methodList = class_copyMethodList(cls, &count);
        for (unsigned i = 0; i < count; i++) {
            Method method = methodList[i];
            SEL sel = method_getName(method);
            NSString *name = NSStringFromSelector(sel);
            block(self, sel, name);
        }
    }
}

+ (void)enumerateClassMethodUsingBlock:(void (^)(Class cls, SEL selector, NSString *name))block {
    NSString *className = NSStringFromClass(self);
    Class metaCls = objc_getMetaClass(className.UTF8String);
    Class cls = objc_getClass(className.UTF8String);
    if (metaCls && cls) {
        unsigned count = 0;
        Method *methodList = class_copyMethodList(metaCls, &count);
        for (unsigned i = 0; i < count; i++) {
            Method method = methodList[i];
            SEL sel = method_getName(method);
            NSString *name = NSStringFromSelector(sel);
            block(cls, sel, name);
        }
    }
}

+ (CLCommandInfo *)generateCommandInfo {
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [self enumerateClassMethodUsingBlock:^(__unsafe_unretained Class cls, SEL selector, NSString *name) {
        if ([name hasPrefix:@"__CL"]) {
            NSString *origin = name;
            origin = [origin stringByReplacingOccurrencesOfString:@"__" withString:@""];
            origin = [origin stringByReplacingOccurrencesOfString:@":" withString:@""];
            NSArray *list = [origin componentsSeparatedByString:@"_"];
            NSAssert(list.count == 3, @"The method is invalide.");
            NSString *_type = list[0];
            int index = [list[1] intValue];
            NSString *name = list[2];
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if ([_type isEqualToString:@"CLARG"]) {
                CLArgumentInfo *info = [[CLArgumentInfo alloc] initWithName:name];
                info.index = arguments.count;
                [cls performSelector:selector withObject:info];
                arguments[name] = info;
                properties[@(index).stringValue] = info;
            }
            else if ([_type isEqualToString:@"CLARY"]) {
                CLArgumentInfo *info = [[CLArgumentInfo alloc] initWithName:name];
                info.index = arguments.count;
                [cls performSelector:selector withObject:info];
                arguments[name] = info;
                properties[@(index).stringValue] = info;
            }
            else if ([_type isEqualToString:@"CLOPT"]) {
                CLOptionInfo *info = [[CLOptionInfo alloc] initWithName:name];
                [cls performSelector:selector withObject:info];
                options[name] = info;
                properties[@(index).stringValue] = info;
            }
            else {
                NSAssert(NO, @"The method is invalide.");
            }
#pragma clang diagnostic pop
        }
    }];
    CLCommandInfo *command = [[CLCommandInfo alloc] initWithName:[self __nameForCommand:self]];
    command.properties = properties;
    command.options = options;
    command.arguments = arguments;
    return command;
}

+ (int)main:(NSArray<NSString *> *)arguments {
    NSMutableArray *precommand = [NSMutableArray array];
    NSMutableArray *sufargs = [arguments mutableCopy];
    NSString *cmd = sufargs.firstObject; [sufargs removeObjectAtIndex:0];
    [precommand addObject:cmd];
    Class current = nil;
    Class next = self;
    while (next) {
        current = next;
        next = [current __nextCommandForPrecommands:precommand arguments:sufargs];
    }
    return [current __main:precommand sufarguments:sufargs];
}

+ (Class)__nextCommandForPrecommands:(NSMutableArray<NSString *> *)precommands arguments:(NSMutableArray<NSString *> *)arguments {
    if (![self respondsToSelector:@selector(subcommands)]) {
        return nil;
    }
    NSString *name = arguments.firstObject;
    NSArray *subcommands = [self subcommands];
    Class cmd = nil;
    for (Class subcmd in subcommands) {
        if ([[self __nameForCommand:subcmd] isEqualToString:name]) {
            cmd = subcmd;
            [arguments removeObjectAtIndex:0];
            break;
        }
    }
    return cmd;
}

+ (int)__main:(NSMutableArray<NSString *> *)precommand sufarguments:(NSMutableArray<NSString *> *)sufarguments {
    CLCommandInfo *info = [self generateCommandInfo];
    CLRunner *runner = [CLRunner runnerWithCommandInfo:info arguments:sufarguments];
    CLRunnableCommand *cmd = [[self alloc] initWithRunner:runner];
    return [cmd main];
}

+ (NSString *)__nameForCommand:(Class<CLParsable>)command {
    NSString *name = nil;
    if ([command respondsToSelector:@selector(name)]) {
        name = command.name;
    }
    if (name) {
        return name;
    }
    return NSStringFromClass(command).lowercaseString;
}

- (instancetype)initWithRunner:(CLRunner *)runner {
    self = [super init];
    if (self) {
        _runner = runner;
        [self enumerateInstanceMethodUsingBlock:^(CLRunnableCommand *self, SEL selector, NSString *name) {
            if ([name hasPrefix:@"__Init"]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self performSelector:selector withObject:runner];
#pragma clang diagnostic pop
            }
        }];
    }
    return self;
}

@end
