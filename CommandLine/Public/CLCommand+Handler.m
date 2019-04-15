//
//  CLCommand+Handler.m
//  CommandLine
//
//  Created by Magic-Unique on 2019/4/12.
//

#import "CLCommand+Handler.h"
#import "CLCommand+Request.h"
#import "CLCommand+Process.h"

@implementation CLCommand (Handler)

+ (CLResponse *)handleProcess {
    return [self handleArguments:[NSProcessInfo processInfo].arguments];
}

+ (CLResponse *)handleArguments:(NSArray *)arguments {
    NSAssert(arguments.count > 0, @"Arguments must contains one or more items");
    NSMutableArray *args = [arguments mutableCopy];
    args[0] = NSProcessInfo.processInfo.arguments.firstObject.lastPathComponent;
    CLCommand *command = [CLCommand commandWithArguments:args];
    CLRequest *request = [command requestWithCommands:command.commandPath arguments:args];
    return [command _processRequest:request];
}

+ (CLResponse *)handleArgc:(int)argc argv:(const char * [])argv {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:argc];
    for (NSUInteger i = 0; i < argc; i++) {
        NSString *item = [NSString stringWithUTF8String:argv[i]];
        [array addObject:item];
    }
    return [self handleArguments:array];
}

@end
