//
//  CLRunner.m
//  CommandLineDemo
//
//  Created by 冷秋 on 2022/8/31.
//  Copyright © 2022 Magic-Unique. All rights reserved.
//

#import "CLRunner.h"
#import "CLCommandInfo.h"

@implementation CLRunner

+ (instancetype)runnerWithCommandInfo:(CLCommandInfo *)commandInfo arguments:(NSMutableArray<NSString *> *)arguments {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    NSMutableArray *values = [NSMutableArray array];
    NSError *error = nil;
    
    NSError *(^ProcessOption)(CLOptionInfo *option) = ^NSError *(CLOptionInfo *option) {
        if (option) {
            if (option.isBOOL) {
                options[option.name] = @"true";
            } else if (arguments.count) {
                options[option.name] = arguments.firstObject;
                [arguments removeObjectAtIndex:0];
            } else {
                return [NSError errorWithDomain:@"" code:1 userInfo:@{NSLocalizedDescriptionKey: @"缺失参数"}];
            }
        } else {
            // unknow key
            return [NSError errorWithDomain:@"" code:2 userInfo:@{NSLocalizedDescriptionKey: @"未知 key"}];
        }
        return nil;
    };
    
    
    while (arguments.count) {
        NSString *item = arguments.firstObject;
        [arguments removeObjectAtIndex:0];
        if ([item hasPrefix:@"--"]) {
            // iskey
            NSString *key = [item substringFromIndex:2];
            CLOptionInfo *option = [commandInfo optionInfoForName:key];
            if ((error = ProcessOption(option))) break;
        }
        else if ([item hasPrefix:@"-"]) {
            // is short
            NSString *_shorts = [item substringFromIndex:1];
            const char *shorts = _shorts.UTF8String;
            for (NSUInteger i = 0; i < _shorts.length; i++) {
                const char item = shorts[i];
                CLOptionInfo *option = [commandInfo optionInfoForShortName:item];
                if ((error = ProcessOption(option))) break;
            }
        }
        else {
            // is value
            [values addObject:item];
        }
    }
    
    if (!error) {
        NSUInteger valueRequireCount = 0;
        for (CLArgumentInfo *info in commandInfo.arguments.allValues) {
            if (info.isArray) {
                continue;
            }
            if (info.isRequired) {
                valueRequireCount++;
            }
        }
        if (values.count < valueRequireCount) {
            error = [NSError errorWithDomain:@"" code:3 userInfo:@{NSLocalizedDescriptionKey: @"缺失参数"}];
        }
    }
    
    // Check require arguments
    for (CLOptionInfo *option in commandInfo.options.allValues) {
        if (!option.isBOOL && option.isRequired) {
            NSString *name = option.name;
            if (options[name] == nil) {
                NSString *msg = [NSString stringWithFormat:@"Lost required option: %@", name];
                error = [NSError errorWithDomain:@"" code:4 userInfo:@{NSLocalizedDescriptionKey: msg}];
                break;
            }
        }
    }
    
    return [[self alloc] initWithCommandInfo:commandInfo options:options arguments:values error:error];
}

- (instancetype)initWithCommandInfo:(CLCommandInfo *)commandInfo options:(NSDictionary *)options arguments:(NSArray<NSString *> *)arguments error:(NSError *)error {
    self = [super init];
    if (self) {
        _commandInfo = commandInfo;
        _options = options;
        _arguments = arguments;
        _error = error;
    }
    return self;
}

- (id)__valueForTag:(NSUInteger)tag {
    NSString *key = @(tag).stringValue;
    CLBaseInfo *info = self.commandInfo.properties[key];
    if ([info isKindOfClass:[CLOptionInfo class]]) {
        CLOptionInfo *option = (CLOptionInfo *)info;
        return self.options[option.name];
    }
    else if ([info isKindOfClass:[CLArgumentInfo class]]) {
        CLArgumentInfo *argument = (CLArgumentInfo *)info;
        if (argument.index < self.arguments.count) {
            if (argument.isArray) {
                return [self.arguments subarrayWithRange:NSMakeRange(argument.index, self.arguments.count - argument.index)];
            } else {
                return self.arguments[argument.index];
            }
        } else {
            return nil;
        }
    }
    else {
        return nil;
    }
    return nil;
}

- (void)__failure:(NSError *)error {
    _error = error;
}

@end
