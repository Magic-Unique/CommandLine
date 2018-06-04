//
//  main.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandLine.h"
#import "CCUtils.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [CLCommand defineCommand:@"cache"
                         explain:@"Manipulate the CocoaPods cache"
                        onCreate:^(CLCommand *command) {
                            
                        } onRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
                            return nil;
                        }];
        [CLCommand defineCommand:@"deintegrate"
                         explain:@"Deintegrate CocoaPods from your project"
                        onCreate:nil
                       onRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
                           return nil;
                       }];
        [CLCommand defineCommand:@"env"
                         explain:@"Display pod environment"
                        onCreate:nil
                       onRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
                           return nil;
                       }];
        [CLCommand defineCommand:@"init"
                         explain:@"Install project dependencies according to versions from a Podfile.lock"
                        onCreate:nil
                       onRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
                           return nil;
                       }];
        [CLCommand defineCommand:@"ipc"
                         explain:@"Inter-process communication"
                        onCreate:nil
                       onRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
                           return nil;
                       }];
        CLCommand *command = [CLCommand defineCommand:@"lib"
                                              explain:@"Develop pods"
                                             onCreate:nil
                                            onRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
                                                return nil;
                                            }];
        command.setQuery(@"require-query").setAbbr('R').setExplain(@"A require query.").require();
        command.setQuery(@"optional-query").setAbbr('O').setExplain(@"An optional query.").optional();
        command.setFlag(@"flag").setAbbr('f').setExplain(@"A test flag.");
        [CLCommand setDefaultTask:^CLResponse *(CLCommand *command, CLRequest *request) {
            printf("task\n");
            return nil;
        }];
        [CLCommand setVersion:@"1.0.0"];
        [CLCommand setExplain:@"CocoaPods, the Cocoa library package manager."];
        [CLCommand handleRequest:[CLRequest request]];
    }
    return 0;
}
