//
//  CLIO.h
//  CommandLine
//
//  Created by Magic-Unique on 2019/4/28.
//

#import <Foundation/Foundation.h>
#import "ANSI.h"
#import "CLDebugger.h"
#import <os/log.h>

#define _CL_LOG_LEVEL(os_level, cl_func, ...) \
if (CLProcessInXcodeSupportOSLog()) { \
    NSString *content = [NSString stringWithFormat:__VA_ARGS__]; \
    os_log_with_type(OS_LOG_DEFAULT, os_level, "%{public}@", content); \
} else {\
    cl_func(__VA_ARGS__); \
}

/**
 Print text without any style
 
 @param format NSString
 @param ... Args
 */
FOUNDATION_EXTERN void CLPrintf(NSString * _Nonnull format, ...);

/**
 Print ANSI test

 @param style CCStyle
 @param format NSString
 @param ... Args
 */
FOUNDATION_EXTERN void CLANSIPrintf(CCStyle style, NSString * _Nonnull format, ...);

/**
 Set indent for output.
 
 The indent will be used at CLVerbose, CLInfo, CLSuccess, CLWarning, CLError, CLLog

 @param indent NSString, default is 4 spaces
 */
FOUNDATION_EXTERN void CLSetIndent(NSString * _Nullable indent);
FOUNDATION_EXTERN void CLPushIndent(void);
FOUNDATION_EXTERN void CLPopIndent(void);

/**
 Print detail text, only enable for --verbose
 
 @param format NSString
 @param ... Args
 */
FOUNDATION_EXTERN void CLVerbose(NSString * _Nonnull format, ...);

/**
 Print light text
 
 @param format NSString
 @param ... Args
 */
FOUNDATION_EXTERN void _CLInfo(NSString * _Nonnull format, ...);

#define CLInfo(...) _CL_LOG_LEVEL(OS_LOG_TYPE_INFO, _CLInfo, __VA_ARGS__)

/**
 Print green text
 
 @param format NSString
 @param ... Args
 */
FOUNDATION_EXTERN void _CLSuccess(NSString * _Nonnull format, ...);

#define CLSuccess(...) _CL_LOG_LEVEL(OS_LOG_TYPE_DEFAULT, _CLSuccess, __VA_ARGS__)

/**
 Print yellow text
 
 @param format NSString
 @param ... Args
 */
FOUNDATION_EXTERN void _CLWarning(NSString * _Nonnull format, ...);

#define CLWarning(...) _CL_LOG_LEVEL(OS_LOG_TYPE_ERROR, _CLWarning, __VA_ARGS__)

/**
 Print red text
 
 @param format NSString
 @param ... Args
 */
FOUNDATION_EXTERN void _CLError(NSString * _Nonnull format, ...);

#define CLError(...) _CL_LOG_LEVEL(OS_LOG_TYPE_FAULT, _CLError, __VA_ARGS__)

/**
 Print in DEBUG mode
 
 @param format NSString
 @param ... Args
 */
FOUNDATION_EXTERN void _CLLog(NSString * _Nonnull format, ...);

#define CLLog(...) _CL_LOG_LEVEL(OS_LOG_TYPE_DEBUG, _CLLog, __VA_ARGS__)

#ifdef DEBUG
/**
 Print object
 
 @param object object
 @param ... other objects
 */
#define CLDebug(...) _CL_DEBUG(@[__VA_ARGS__])

FOUNDATION_EXTERN void _CL_DEBUG(NSArray * _Nonnull objects);

#else

#define CLDebug(...)

#endif
