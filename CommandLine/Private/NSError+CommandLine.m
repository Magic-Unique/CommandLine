//
//  NSError+CommandLine.m
//  CommandLine
//
//  Created by Magic-Unique on 2018/11/28.
//

#import "NSError+CommandLine.h"
#import "CLLanguage+Private.h"
#import "CCText.h"

NSError *CLIllegalQueryError(NSString *key, NSString *value) {
    key = CCText(CCStyleItalic, key);
    value = CCText(CCStyleForegroundColorDarkRed, value);
    NSString *reason = [NSString stringWithFormat:CLCurrentLanguage.errorIllegalValue, key, value];
    return [NSError errorWithDomain:CLErrorDomain
                               code:1
                           userInfo:@{CLErrorPrintInformationKey:reason}];
}

NSError *CLUnknowQueryError(NSString *key) {
    key = CCText(CCStyleForegroundColorDarkRed, key);
    NSString *reason = [NSString stringWithFormat:CLCurrentLanguage.errorUnknowQuery, key];
    return [NSError errorWithDomain:CLErrorDomain
                               code:1
                           userInfo:@{CLErrorPrintInformationKey:reason}];
}

NSError *CLErrorWithPrintInformation(CLErrorCode code, NSString *infomation) {
    return [NSError errorWithDomain:CLErrorDomain code:code userInfo:@{CLErrorPrintInformationKey:infomation}];
}
