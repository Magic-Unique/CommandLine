//
//  NSArray+CommandLine.h
//  CommandLineDemo
//
//  Created by Magic-Unique on 2018/7/20.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CommandLine)

- (NSUInteger)cl_sort:(NSComparator)cmptr enumerate:(void (^)(id obj, NSUInteger idx, BOOL *stop))enumerate;

@end
