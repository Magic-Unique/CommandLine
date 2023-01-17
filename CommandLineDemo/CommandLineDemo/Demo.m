//
//  Demo.m
//  CommandLineDemo
//
//  Created by 冷秋 on 2019/12/18.
//  Copyright © 2023 Magic-Unique. All rights reserved.
//

#import "Demo.h"
#import "Subdemo.h"

@implementation Demo

+ command_configuration() {
    configuration.name = @"aaa";
    configuration.note = @"This is a demo command";
}

//+ command_subcommands(ABSubdemo, ABSubdemo)

+ command_option(CLPath, input, shortName='i', nonnull, note=@"Input path.")
+ command_option(CLString, output, shortName='o', nullable, note=@"Output path.")
+ command_option(CLBool, replace, shortName='R', note=@"Replace current file.")
+ command_option(int, zipLevel, shortName='z', nonnull, note=@"0-9 level for zip.")
+ command_option(NSUInteger, deep, nonnull, placeholder=@"THE_DEEP", note=@"0-9 level for zip.")

+ command_argument(CLString, arg1, nonnull, placeholder=@"/path/to/arg1", note=@"Input path")
+ command_argument(CLString, arg2, nullable, note=@"Input path")

+ command_arguments(CLString, array)

+ command_main() {
    NSLog(@"_input = %@", input);
    NSLog(@"self.input = %@", self.input);
    NSLog(@"_output = %@", output);
    NSLog(@"self.output = %@", self.output);
    NSLog(@"_replace = %d", replace.isTrue);
    NSLog(@"self.replace = %d", self.replace.isTrue);
    return 0;
}

@end
