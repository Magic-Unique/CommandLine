//
//  NSError+CommandLine.h
//  CommandLine
//
//  Created by Magic-Unique on 2018/11/28.
//

#import <Foundation/Foundation.h>
#import "CLError.h"

FOUNDATION_EXTERN NSError *CLIllegalQueryError(NSString *key, NSString *value);

FOUNDATION_EXTERN NSError *CLUnknowQueryError(NSString *key);

FOUNDATION_EXTERN NSError *CLErrorWithPrintInformation(CLErrorCode code, NSString *infomation);
