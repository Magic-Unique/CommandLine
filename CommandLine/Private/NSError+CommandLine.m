//
//  NSError+CommandLine.m
//  CommandLine
//
//  Created by 吴双 on 2018/11/28.
//

#import "NSError+CommandLine.h"
#import "CLLanguage+Private.h"
#import "CCText.h"

NSErrorUserInfoKey const CLParseErrorReasonKey = @"CLParseErrorReasonKey";

@implementation NSError (CommandLine)

+ (instancetype)cl_illegalValueForQuery:(NSString *)query value:(NSString *)value {
    query = CCText(CCStyleItalic, query);
    value = CCText(CCStyleForegroundColorDarkRed, value);
    NSString *reason = [NSString stringWithFormat:CLCurrentLanguage.errorIllegalValue, query, value];
    return [self errorWithDomain:@"com.commandline.parse.IllegalValue"
                            code:1
                        userInfo:@{CLParseErrorReasonKey:reason}];
}

+ (instancetype)cl_unknowQuery:(NSString *)query {
    query = CCText(CCStyleForegroundColorDarkRed, query);
    NSString *reason = [NSString stringWithFormat:CLCurrentLanguage.errorUnknowQuery, query];
    return [self errorWithDomain:@"com.commandline.parse.UnknowQuery"
                            code:1
                        userInfo:@{CLParseErrorReasonKey:reason}];
}

@end
