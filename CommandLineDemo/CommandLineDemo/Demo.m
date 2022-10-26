//
//  Demo.m
//  CommandLineDemo
//
//  Created by 吴双 on 2019/12/18.
//  Copyright © 2019 unique. All rights reserved.
//

#import "Demo.h"
#import "Subdemo.h"

@implementation Demo

//+ command_name(demo)

+ command_note(@"This is a demo command");

+ command_subcmd(ABSubdemo, ABSubdemo)

- input_option(CLPath, input, shortName='i', nonnull, note=@"Input path.")
- input_option(CLString, output, shortName='o', nullable, note=@"Output path.")
- input_option(CLBool, replace, shortName='R', note=@"Replace current file.")
- input_option(int, zipLevel, shortName='z', nonnull, note=@"0-9 level for zip.")
- input_option(NSUInteger, deep, nonnull, note=@"0-9 level for zip.")

- input_argument(CLString, input1, nonnull, note=@"Input path")
- input_argument(CLString, input2, note=@"Input path")

- input_array(CLString, array)

- command_main() {
    NSLog(@"_input = %@", input);
    NSLog(@"self.input = %@", self.input);
    NSLog(@"_output = %@", output);
    NSLog(@"self.output = %@", self.output);
    NSLog(@"_replace = %d", replace.isTrue);
    NSLog(@"self.replace = %d", self.replace.isTrue);
    return 0;
}

@end
