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
    
    if (launchDirectory) {
        task.currentDirectoryPath = launchDirectory;
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

NSString *CLCurrentDirectory(void) {
    char *cwd = getcwd(NULL, 0);
    NSString *current = [NSString stringWithUTF8String:cwd];
    free(cwd);
    return current;
}

int CLChangeDirectory(NSString *directory) {
    return chdir(directory.UTF8String);
}
