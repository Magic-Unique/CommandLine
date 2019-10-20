//
//  CLWorkDirectory.m
//  CommandLine
//
//  Created by 冷秋 on 2019/6/6.
//

#import "CLWorkDirectory.h"

NSString *CLCurrentDirectory(void) {
    char *cwd = getcwd(NULL, 0);
    NSString *current = [NSString stringWithUTF8String:cwd];
    free(cwd);
    return current;
}

int CLChangeDirectory(NSString *directory) {
    return chdir(directory.UTF8String);
}

