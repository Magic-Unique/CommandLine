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

static void _CLInitCommand(Class class) {
    unsigned count = 0;
    Method *methodList = class_copyMethodList(object_getClass(class), &count);
    for (unsigned i = 0; i < count; i++) {
        Method method = methodList[i];
        SEL sel = method_getName(method);
        NSString *name = NSStringFromSelector(sel);
        if ([name hasPrefix:@"__cl_def_"]) {
            NSMutableArray *names = [[[name substringFromIndex:@"__cl_def_".length] componentsSeparatedByString:@":"] mutableCopy];
            [names removeLastObject];
            NSMethodSignature *methodSignature = [class methodSignatureForSelector:sel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            invocation.target = class;
            invocation.selector = sel;
            
            NSMutableArray<CLCommand *> *commands = [NSMutableArray arrayWithCapacity:names.count];
            for (NSUInteger i = 0; i < names.count; i++) {
                CLCommand *cmd = nil;
                if (i == 0) {
                    cmd = [CLCommand mainCommand];
                } else {
                    cmd = [commands.lastObject defineSubcommand:names[i]];
                }
                [commands addObject:cmd];
                [invocation setArgument:&cmd atIndex:2+i];
            }
            [invocation retainArguments];
            [invocation invoke];
        }
    }
}

#define CLInitCommand(_class) (_class *)0x0; _CLInitCommand([_class class]);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        CLMainExplain = @"My explain for main command.";
        CLInitCommand(CLCommand);
        CLCommandMain();
    }
    return 0;
}
