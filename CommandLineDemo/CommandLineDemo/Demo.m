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

- input_option(CLString, input, shortName='i', note=@"Input path.")
- input_option(CLString, output, shortName='o', note=@"Output path.")
- input_option(CLBool, replace, shortName='R', note=@"Replace current file.")

- input_argument(CLString, input1, note=@"Input path")
- input_argument(CLString, input2, note=@"Input path")

- input_array(CLString, array)

- (int)main {
    NSLog(@"_input = %@", input);
    NSLog(@"self.input = %@", self.input);
    NSLog(@"_output = %@", output);
    NSLog(@"self.output = %@", self.output);
    return 0;
}

+ (NSArray<Class> *)subcommands {
    return @[[Subdemo class]];
}

@end
