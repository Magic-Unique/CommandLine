//
//  CLRequest.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLCommand;

@interface CLRequest : NSObject

@property (nonatomic, strong, readonly, nonnull) NSArray *commands;

/**
 All inputed queries.
 
 Contains: queries inputed by user, optional queries with default value but not inputed.
 Key is query's key, value is an array (if query is multiable) or a string.
 */
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSString *, id> *queries;

/**
 All inputed flags.
 */
@property (nonatomic, strong, readonly, nullable) NSSet *flags;

/**
 All inputed paths
 */
@property (nonatomic, strong, readonly, nullable) NSArray *paths;

/**
 Error for parsing request.
 */
@property (nonatomic, strong, readonly, nullable) NSError *error;

/**
 Get string from queries

 @param query Key
 @return NSString
 */
- (NSString * _Nullable)stringForQuery:(NSString * _Nonnull)query;

/**
 Get full path from queries

 @param query Key
 @return NSString
 */
- (NSString * _Nullable)pathForQuery:(NSString * _Nonnull)query;

/**
 Get integer from queries

 @param query Key
 @return NSInteger
 */
- (NSInteger)integerValueForQuery:(NSString * _Nonnull)query;

/**
 Contains a flag

 @param flag Key
 @return BOOL
 */
- (BOOL)flag:(NSString * _Nonnull)flag;

/**
 Get IO path at index

 @param index Index of path
 @return NSString
 */
- (NSString * _Nullable)pathForIndex:(NSUInteger)index;

@end

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
