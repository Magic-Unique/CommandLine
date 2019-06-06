//
//  CLIO.h
//  CommandLine
//
//  Created by Magic-Unique on 2019/4/28.
//

#import <Foundation/Foundation.h>

/**
 Print text without any style
 
 @param format NSString
 @param ... Args
 */
FOUNDATION_EXTERN void CLPrintf(NSString * _Nonnull format, ...);

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
