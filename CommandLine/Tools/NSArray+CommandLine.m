//
//  NSArray+CommandLine.m
//  CommandLine
//
//  Created by Magic-Unique on 2026/6/14.
//

#import "NSArray+CommandLine.h"

@implementation NSArray (CommandLine)

@end

@implementation NSMutableArray (CommandLine)

- (NSMutableArray *)cl_takeWithFilter:(BOOL (^)(id obj))block {
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.count; i++) {
        id obj = self[i];
        if (block(obj)) {
            [result addObject:obj];
            [self removeObjectAtIndex:i--];
        }
    }
    return result;
}

@end
