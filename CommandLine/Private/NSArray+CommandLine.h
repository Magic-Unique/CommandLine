//
//  NSArray+CommandLine.h
//  CommandLineDemo
//
//  Created by 吴双 on 2018/7/20.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CommandLine)

- (void)cl_sort:(NSComparator)cmptr enumerate:(void (^)(id obj, NSUInteger idx, BOOL *stop))enumerate;

@end
