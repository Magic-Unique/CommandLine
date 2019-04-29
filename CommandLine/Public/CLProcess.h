//
//  CLProcess.h
//  CommandLine
//
//  Created by Magic-Unique on 2019/4/28.
//

#import <Foundation/Foundation.h>

@class CLCommand;

@interface CLProcess : NSObject

+ (instancetype _Nonnull)sharedProcess;

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
 Error for parsing arguments.
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
