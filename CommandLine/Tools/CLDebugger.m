//
//  CLTerminal.m
//  CommandLineDemo
//
//  Created by 冷秋 on 2018/6/3.
//  Copyright © 2023 Magic-Unique. All rights reserved.
//

#import "CLDebugger.h"
#include <sys/sysctl.h>

BOOL CLProcessIsAttached(void) {
    size_t size = sizeof(struct kinfo_proc);
    struct kinfo_proc info;
    int ret, name[4];
    memset(&info, 0, sizeof(struct kinfo_proc));
    name[0] = CTL_KERN;
    name[1] = KERN_PROC;
    name[2] = KERN_PROC_PID;
    name[3] = getpid();
    if ((ret = (sysctl(name, 4, &info, &size, NULL, 0)))) {
        return ret; /* sysctl() failed for some reason */
    }
    return (info.kp_proc.p_flag & P_TRACED) ? YES : NO;
}

BOOL CLProcessInXcodeConsole(void) {
    NSString *str = CLEnvironment[@"__CFBundleIdentifier"];
    if ([str.lowercaseString containsString:@"xcode"]) {
        return YES;
    }
    return NO;
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
