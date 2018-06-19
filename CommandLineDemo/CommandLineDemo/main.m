//
//  main.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandLine.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        CLCommand *cache = [CLCommand.main defineSubcommand:@"cache"];
        cache.explain = @"Manipulate the CocoaPods cache";
        [cache onHandlerRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
            return nil;
        }];
        CLCommand *deintegrate = [CLCommand.main defineSubcommand:@"deintegrate"];
        deintegrate.explain = @"Deintegrate CocoaPods from your project";
        [deintegrate onHandlerRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
            return nil;
        }];
        CLCommand *env = [CLCommand.main defineSubcommand:@"env"];
        env.explain = @"Display pod environment";
        [env onHandlerRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
            return nil;
        }];
        [CLCommand handleRequest:[CLRequest request]];
    }
    return 0;
}
