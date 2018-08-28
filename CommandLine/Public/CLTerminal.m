//
//  CLTerminal.m
//  CommandLineDemo
//
//  Created by 冷秋 on 2018/6/3.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLTerminal.h"
#import "CLIOPath.h"

int CLSystem(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    return system(str.UTF8String);
}

void CLPrintf(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    printf("%s", str.UTF8String);
}

NSString *CLLaunch(NSArray *arguments) {
    NSString *launchPath = arguments.firstObject;
    if (arguments.count > 1) {
        arguments = [arguments subarrayWithRange:NSMakeRange(1, arguments.count - 1)];
    }
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = [CLIOPath abslutePath:launchPath];
    
    if (arguments.count) {
        task.arguments = arguments;
    }
    task.standardOutput = [NSPipe pipe];
    task.standardError = task.standardOutput;
    [task launch];
    [task waitUntilExit];
    NSPipe *pipe = task.standardOutput;
    NSData *data = pipe.fileHandleForReading.availableData;
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (task.terminationStatus == EXIT_SUCCESS) {
        return string ?: @"";
    } else {
        return nil;
    }
}

NSString *CLLaunchEx(NSString *launchPath, ...) {
    NSMutableArray *arguments = [NSMutableArray array];
    va_list v;
    va_start(v, launchPath);
    NSString *item = nil;
    while ((item = va_arg(v, NSString *))) {
        if ([item isKindOfClass:[NSString class]] == NO) {
            assert(0);// CLLaunch only reqires NSString object.
        }
        [arguments addObject:item];
    }
    va_end(v);
    
    [arguments insertObject:launchPath atIndex:0];
    return CLLaunch(arguments);
}

NSString *CLLaunchAt(NSString *directory, NSArray *arguments) {
    NSString *launchPath = arguments.firstObject;
    if (arguments.count > 1) {
        arguments = [arguments subarrayWithRange:NSMakeRange(1, arguments.count - 1)];
    }
    NSTask *task = [[NSTask alloc] init];
    if (directory) {
        task.currentDirectoryPath = [CLIOPath abslutePath:directory];
    }
    task.launchPath = [CLIOPath abslutePath:launchPath];
    if (arguments.count) {
        task.arguments = arguments;
    }
    task.standardOutput = [NSPipe pipe];
    task.standardError = task.standardOutput;
    [task launch];
    [task waitUntilExit];
    NSPipe *pipe = task.standardOutput;
    NSData *data = pipe.fileHandleForReading.availableData;
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (task.terminationStatus == EXIT_SUCCESS) {
        return string ?: @"";
    } else {
        return nil;
    }
}

NSString *CLLaunchAtEx(NSString *directory, NSString *launchPath, ...) {
    NSMutableArray *arguments = [NSMutableArray array];
    va_list v;
    va_start(v, launchPath);
    NSString *item = nil;
    while ((item = va_arg(v, NSString *))) {
        if ([item isKindOfClass:[NSString class]] == NO) {
            assert(0);// CLLaunch only reqires NSString object.
        }
        [arguments addObject:item];
    }
    va_end(v);
    
    [arguments insertObject:launchPath atIndex:0];
    return CLLaunchAt(directory, arguments);
}

NSString *CLCurrentDirectory(void) {
    char *cwd = getcwd(NULL, 0);
    NSString *current = [NSString stringWithUTF8String:cwd];
    free(cwd);
    return current;
}

int CLChangeDirectory(NSString *directory) {
    return chdir(directory.UTF8String);
}
