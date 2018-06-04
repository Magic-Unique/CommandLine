//
//  NSMutableString+CommandLine.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/22.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CommandLine)

+ (instancetype)cl_stringWithSpace:(NSUInteger)length;

@end

@interface NSMutableString (CommandLine)

- (void)cl_appendLine:(NSString *)format, ...;

- (void)cl_appendTab:(NSUInteger)count;

- (void)cl_appendNewLine:(NSUInteger)count;

@end
