//
//  CLError.h
//  CommandLine
//
//  Created by Magic-Unique on 2019/4/15.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSErrorDomain CLErrorDomain;

FOUNDATION_EXTERN NSErrorUserInfoKey CLErrorPrintInformationKey;

typedef NS_ENUM(NSUInteger, CLErrorCode) {
    CLUnknowError,
    CLMissingRequireQueriesError,
    CLMissingPathsError,
};
