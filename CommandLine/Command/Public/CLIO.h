//
//  CLIO.h
//  CommandLine
//
//  Created by Magic-Unique on 2019/4/28.
//

#import <Foundation/Foundation.h>
#import "ANSI.h"

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
FOUNDATION_EXTERN void CLInfo(NSString * _Nonnull format, ...);

/**
 Print green text
 
 @param format NSString
 @param ... Args
 */
FOUNDATION_EXTERN void CLSuccess(NSString * _Nonnull format, ...);

/**
 Print yellow text
 
 @param format NSString
 @param ... Args
 */
FOUNDATION_EXTERN void CLWarning(NSString * _Nonnull format, ...);

/**
 Print red text
 
 @param format NSString
 @param ... Args
 */
FOUNDATION_EXTERN void CLError(NSString * _Nonnull format, ...);

/**
 Print in DEBUG mode
 
 @param format NSString
 @param ... Args
 */
FOUNDATION_EXTERN void CLLog(NSString * _Nonnull format, ...);

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
