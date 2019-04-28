//
//  NSArray+CommandLine.m
//  CommandLineDemo
//
//  Created by Magic-Unique on 2018/7/20.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "NSArray+CommandLine.h"

@implementation NSArray (CommandLine)

- (NSUInteger)cl_sort:(NSComparator)cmptr enumerate:(void (^)(id _Nonnull, NSUInteger, BOOL * _Nonnull))enumerate {
    NSArray *sorted = cmptr?[self sortedArrayUsingComparator:cmptr]:self;
    [sorted enumerateObjectsUsingBlock:enumerate];
    return self.count;
}

@end
