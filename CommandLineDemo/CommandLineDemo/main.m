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

        CLCommand *print = [CLCommand.main defineSubcommand:@"print"];
        print.explain = @"Print file informations";
        print.setFlag(@"en").setExplain(@"Print with English");
        print.addRequirePath(@"input").setExample(@"/path/to/file").setExplain(@"Input file path");
        [print onHandlerRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
            return nil;
        }];
        [CLCommand main].explain = @"My explain for main command.";
//        NSString *output = CLLaunchAt(nil, @"/usr/bin/security", @"find-identity", @"-v", @"-p", @"codesigning", nil);
//        NSArray *items = [output componentsSeparatedByString:@"\n"];
//        NSRegularExpression *identifierRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Fa-f0-9]{40}" options:NSRegularExpressionCaseInsensitive error:nil];
//        NSRegularExpression *nameRegular = [NSRegularExpression regularExpressionWithPattern:@"\".*\"" options:NSRegularExpressionCaseInsensitive error:nil];
//        for (NSString *item in items) {
//            NSRange range = [identifierRegular rangeOfFirstMatchInString:item options:NSMatchingReportProgress range:NSMakeRange(0, item.length)];
//            if (range.length == 0) {
//                continue;
//            }
//            NSString *identifier = [item substringWithRange:range];
//            range = [nameRegular rangeOfFirstMatchInString:item options:NSMatchingReportProgress range:NSMakeRange(0, item.length)];
//            if (range.length == 0) {
//                continue;
//            }
//            NSString *name = [item substringWithRange:range];
//            NSLog(@"%@ %@", identifier, name);
//        }
//        CLPrintf(@"%@", items);
        
        CLCommandMain();
    }
    return 0;
}
