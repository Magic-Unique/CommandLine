//
//  CLTerminal.m
//  CommandLineDemo
//
//  Created by 冷秋 on 2018/6/3.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLTerminal.h"

int CLSystem(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    return system(str.UTF8String);
}

NSString *CLLaunch(NSString *launchDirectory, ...) {
    NSMutableArray *arguments = [NSMutableArray array];
    va_list v;
    va_start(v, launchDirectory);
    id argv = nil;
    while ((argv = va_arg(v, id))) {
        if ([argv isKindOfClass:[NSString class]]) {
            [arguments addObject:argv];
            continue;
        }
        if ([argv isKindOfClass:[NSArray class]]) {
            [arguments addObjectsFromArray:argv];
            continue;
        }
        argv = nil;
        NSCParameterAssert(argv);
    }
    va_end(v);
    
    NSString *launchPath = arguments.firstObject;
    [arguments removeObjectAtIndex:0];
    
    NSTask *task = [[NSTask alloc] init];
    task.environment = [NSProcessInfo processInfo].environment;
    
    if (launchDirectory) {
        task.currentDirectoryPath = launchDirectory;
    }
    
    task.launchPath = launchPath;
    
    if (arguments.count) {
        task.arguments = arguments;
    }
    NSPipe *pipe = [NSPipe pipe];
    task.standardOutput = pipe;
    task.standardError = pipe;
    [task launch];
    
    NSMutableData *data = [NSMutableData data];
    while (task.isRunning) {
        NSData *avaliable = pipe.fileHandleForReading.availableData;
        if (avaliable.length) {
            [data appendData:avaliable];
        }
    }
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (task.terminationStatus == EXIT_SUCCESS) {
        return string ?: @"";
    } else {
        return nil;
    }
}

@implementation _CLEnvironment

+ (instancetype _Nonnull)environment {
    static _CLEnvironment *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (void)setObject:(NSString * _Nullable)obj forKeyedSubscript:(NSString * _Nonnull)key {
    if (obj) {
        setenv(key.UTF8String, obj.UTF8String, 0);
    } else {
        unsetenv(key.UTF8String);
    }
}

- (NSString * _Nullable)objectForKeyedSubscript:(NSString * _Nonnull)key {
    char *_key = getenv(key.UTF8String);
    if (_key) {
        NSString *string = [NSString stringWithUTF8String:_key];
        return string;
    } else {
        return nil;
    }
}

- (NSString *)description {
    return NSProcessInfo.processInfo.environment.description;
}

@end
