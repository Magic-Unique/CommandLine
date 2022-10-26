//
//  CLAbstractCommand.m
//  CommandLineDemo
//
//  Created by 吴双 on 2022/8/31.
//  Copyright © 2022 unique. All rights reserved.
//

#import "CLAbstractCommand.h"
#import <objc/runtime.h>
#import <CommandLine/CLHelpBanner.h>

static NSString *GenName(NSString *nsClassName) {
    int lastIndex = -1;
    for (int i = 0; i < nsClassName.length; i++) {
        char current = nsClassName.UTF8String[i];
        if (current >= 'A' && current <= 'Z') {
            lastIndex ++;
        } else {
            break;
        }
    }
    if (lastIndex == -1) {
        lastIndex = 0;
    }
    NSMutableString *name = [NSMutableString string];
    for (int i = lastIndex; i < nsClassName.length; i++) {
        char current = nsClassName.UTF8String[i];
        if (current >= 'A' && current <= 'Z') {
            [name appendFormat:@"-%c", (current - 'A' + 'a')];
        } else {
            [name appendFormat:@"%c", current];
        }
    }
    if ([name hasPrefix:@"-"]) {
        [name deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    return name;
}

@implementation CLAbstractCommand

- (void)enumerateInstanceMethodUsingBlock:(void (^)(CLAbstractCommand *self, SEL selector, NSString *name))block {
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
                info.isArray = YES;
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
    CLCommandInfo *command = [[CLCommandInfo alloc] initWithName:[self name]];
    command.note = [self note];
    command.properties = properties;
    command.options = options;
    command.arguments = arguments;
    command.subcommands = ({
        NSMutableDictionary *subcommands = [NSMutableDictionary dictionary];
        for (Class subclass in [self subcommands]) {
            CLCommandInfo *commandInfo = [[CLCommandInfo alloc] initWithName:[subclass name]];
            commandInfo.note = [subclass note];
            subcommands[commandInfo.name] = commandInfo;
        }
        subcommands;
    });
    command.runnable = [self instancesRespondToSelector:@selector(main)];
    return command;
}

+ (int)main {
    return [self main:NSProcessInfo.processInfo.arguments];
}

+ (int)main:(int)argc argv:(const char *[])argv {
    NSMutableArray *arguments = [NSMutableArray array];
    for (int i = 0; i < argc; i++) {
        const char *item = argv[i];
        NSString *_str = [NSString stringWithUTF8String:item];
        [arguments addObject:_str];
    }
    return [self main:arguments];
}

+ (int)main:(NSArray<NSString *> *)arguments {
    NSMutableArray<NSString *> *precommand = [NSMutableArray array];
    NSMutableArray<NSString *> *sufargs = [arguments mutableCopy];
    [precommand addObject:sufargs.firstObject.lastPathComponent];
    [sufargs removeObjectAtIndex:0];
    Class current = nil;
    Class next = self;
    while (next) {
        current = next;
        next = [current __nextCommandForPrecommands:precommand arguments:sufargs];
    }
    return [current __handle:precommand sufarguments:sufargs];
}

+ (Class)__nextCommandForPrecommands:(NSMutableArray<NSString *> *)precommands arguments:(NSMutableArray<NSString *> *)arguments {
    if (![self respondsToSelector:@selector(subcommands)]) {
        return nil;
    }
    NSString *name = arguments.firstObject;
    NSArray *subcommands = [self subcommands];
    Class cmd = nil;
    for (Class subcmd in subcommands) {
        if ([[subcmd name] isEqualToString:name]) {
            cmd = subcmd;
            [precommands addObject:arguments.firstObject];
            [arguments removeObjectAtIndex:0];
            break;
        }
    }
    return cmd;
}

+ (int)__handle:(NSMutableArray<NSString *> *)precommand sufarguments:(NSMutableArray<NSString *> *)sufarguments {
    CLCommandInfo *info = [self generateCommandInfo];
    NSAssert([self __validity], @"The command %@ must contains +command_subcommand list or -main function", self);
    CLRunner *runner = [CLRunner runnerWithCommandInfo:info arguments:sufarguments];
    if (runner.error) {
        [CLHelpBanner printHelpBannerForPrecommands:precommand commandInfo:info error:runner.error];
        return (int)runner.error.code;
    }
    CLAbstractCommand *cmd = [[self alloc] initWithRunner:runner];
    return [cmd main];
}

- (instancetype)initWithRunner:(CLRunner *)runner {
    self = [super init];
    if (self) {
        _runner = runner;
        [self enumerateInstanceMethodUsingBlock:^(CLAbstractCommand *self, SEL selector, NSString *name) {
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

+ (NSString *)name { return GenName(NSStringFromClass(self)); }
+ (NSString *)note { return nil; }
+ (NSArray<Class> *)subcommands { return nil; }

+ (BOOL)__validity {
    BOOL containsSubcmds = ([self subcommands].count > 0);
    BOOL containsEntry = [self instancesRespondToSelector:@selector(main)];
    return containsSubcmds || containsEntry;
}

@end