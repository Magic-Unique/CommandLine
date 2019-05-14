//
//  NSMutableString+CommandLine.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/22.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *CLSpaceString(NSUInteger length);

FOUNDATION_EXTERN BOOL CLStringMatches(NSString *string, NSString *regularExpression);

@interface NSMutableString (CommandLine)

- (void)cl_appendLine:(NSString *)format, ...;

- (void)cl_appendTab:(NSUInteger)count;

- (void)cl_appendNewLine:(NSUInteger)count;

@end

FOUNDATION_EXTERN BOOL CLArgumentIsKey(NSString *argument);
FOUNDATION_EXTERN BOOL CLArgumentIsAbbr(NSString *argument);
FOUNDATION_EXTERN BOOL CLArgumentIsKeyOrAbbr(NSString *argument);
FOUNDATION_EXTERN NSString *CLGetKeyFromArgument(NSString *argument);
FOUNDATION_EXTERN char CLGetAbbrFromArgument(NSString *argument);

FOUNDATION_EXTERN NSString *const CLRegularNumber;  ///< ^(\-|\+)?\d+(\.\d+)?$
FOUNDATION_EXTERN NSString *const CLRegularPath;
