//
//  main.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2023 Magic-Unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommandLine/CommandLine.h>
#import <objc/runtime.h>
#include <stdio.h>
#include <stdlib.h>
#import "Demo.h"
#import "Subdemo.h"

#define CLInitCommand(_class) (_class *)0x0; _CLInitCommand([_class class]);

__unused static NSString *RandomString(void) {
    NSString *format = @"0123456789abcdef";
    NSMutableString *string = [NSMutableString string];
    NSUInteger randomLength = arc4random() % 20 + 4;
    for (NSUInteger i = 0; i < randomLength; i++) {
        NSUInteger randomIndex = arc4random() % format.length;
        NSString *charactor = [format substringWithRange:NSMakeRange(randomIndex, 1)];
        [string appendString:charactor];
    }
    return string.copy;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        CLMakeSubcommand(Demo, __init_);
//        CLCommandMain();
//        CLInfo(@"info");
//        CLWarning(@"warning");
//        CLError(@"error");
//        CLVerbose(@"verbose");
//        CLDebug(@"debug", @"debug2");
//        CLLog(@"log");
        [CLDefaultHelpBannerProvider sharedProvider].sortMethod = CLDefaultHelpBannerSortMethodIndex;
        return [Demo main];
//        return [Demo main:@[@"tool", @"bb", @"-R", @"--input", @"This is input", @"-o", @"This is output", @"I1", @"I2"]];
        
//#define PrintColor(c) @#c @"\n".ansi. c . _##c .flash.print();
//        PrintColor(black)
//        PrintColor(red)
//        PrintColor(green)
//        PrintColor(yellow)
//        PrintColor(blue)
//        PrintColor(purple)
//        PrintColor(darkGreen)
//        PrintColor(white)
        
//#define MULTISELECTOR
//        
//#ifdef MULTISELECTOR
////        CLMultiSelector *mSelector = [CLMultiSelector selector];
////        NSArray *selectList = [mSelector select:list render:^NSString *(id item) {
////            return item;
////        }];
////        CLSuccess(@"You select: %@", selectList);
////        [CLCursor clear];
//        
////        [[CLLoadingIndicator indicatorWithType:CLLoadingIndicatorTypeCycleVolumes] applyDefaultIndicator];
////        CLLoading *loading = [CLLoading loading];
////        loading.text = @"Waiting";
////        [loading start];
////        [NSThread sleepForTimeInterval:3];
////        [loading stop];
//        
//        CLProgress *progress = [CLProgress progressWithProgressBar:[CLProgressBar progressBarWithType:CLProgressBarStyleFullBar]];
//        progress.text = @"loading";
//        [progress start];
//        for (NSUInteger i = 0; i < 100; i++) {
//            progress.progress = i / 100.0;
//            [NSThread sleepForTimeInterval:0.03];
//        }
//        [progress stop];
//#else
//        CLSingleSelector *sSelector = [CLSingleSelector selector];
//        NSUInteger index = [sSelector select:list render:^NSString *(id item) {
//            return item;
//        }];
//        CLSuccess(@"You select: %@", list[index]);
//#endif
    }
    return 0;
}
