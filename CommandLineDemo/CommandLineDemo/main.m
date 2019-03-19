//
//  main.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommandLine/CommandLine.h>
#import <objc/runtime.h>
#include <stdio.h>
#include <stdlib.h>
#import <CommandLine/CLLanguage.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        CLMainExplain = @"My explain for main command.";
        CLMakeSubcommand(CLCommand, __init_);
        CLCommandMain();
    }
    return 0;
}
