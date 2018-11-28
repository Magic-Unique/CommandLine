//
//  NSError+CommandLine.h
//  CommandLine
//
//  Created by 吴双 on 2018/11/28.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSErrorUserInfoKey const CLParseErrorReasonKey;

@interface NSError (CommandLine)

+ (instancetype)cl_illegalValueForQuery:(NSString *)query value:(NSString *)value;

+ (instancetype)cl_unknowQuery:(NSString *)query;

@end
