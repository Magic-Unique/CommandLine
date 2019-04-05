//
//  NSMutableString+CommandLine.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/22.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "NSString+CommandLine.h"

@implementation NSString (CommandLine)

+ (instancetype)cl_stringWithSpace:(NSUInteger)length {
    NSMutableString *string = [NSMutableString new];
    for (NSUInteger i = 0; i < length; i++) {
        [string appendString:@" "];
    }
    return [string copy];
}

- (BOOL)cl_matches:(NSString *)regularExpression {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpression];
    return [predicate evaluateWithObject:self];
}

@end

@implementation NSMutableString (CommandLine)

- (void)cl_appendLine:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    [self appendFormat:@"%@\n", str];
}

- (void)cl_appendTab:(NSUInteger)count {
    for (NSUInteger i = 0; i < count; i++) {
        [self appendString:@"\t"];
    }
}

- (void)cl_appendNewLine:(NSUInteger)count {
    for (NSUInteger i = 0; i < count; i++) {
        [self appendString:@"\n"];
    }
}

@end

BOOL CLArgumentIsKey(NSString *argument) {
    return [argument hasPrefix:@"--"] && argument.length > 2;
}

BOOL CLArgumentIsAbbr(NSString *argument) {
    return [argument hasPrefix:@"--"] == NO && [argument hasPrefix:@"-"] && argument.length > 1;
}

BOOL CLArgumentIsKeyOrAbbr(NSString *argument) {
    return CLArgumentIsKey(argument) || CLArgumentIsAbbr(argument);
}

NSString *CLGetKeyFromArgument(NSString *argument) {
    return [argument substringFromIndex:2];
}

char CLGetAbbrFromArgument(NSString *argument) {
    return [argument characterAtIndex:1];
}

NSString *const CLRegularNumber = @"^(\\-|\\+)?\\d+(\\.\\d+)?$";
NSString *const CLRegularPath = nil;
