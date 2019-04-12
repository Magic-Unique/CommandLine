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
 Handler command
 */
@property (nonatomic, strong, readonly, nonnull) CLCommand *command;

/**
 Error for parsing request.
 */
@property (nonatomic, strong, readonly, nullable) NSError *illegalError;

/**
 Create request with NSProcessInfo.arguments

 @return CLRequest
 */
+ (instancetype _Nonnull)request;

/**
 Create request with main() arguments

 @param argc argc
 @param argv argv
 @return CLRequest
 */
+ (instancetype _Nonnull)requestWithArgc:(int)argc argv:(const char * _Nonnull [_Nonnull])argv;

/**
 Create request with arguments

 @param arguments NSArray
 @return CLRequest
 */
+ (instancetype _Nonnull)requestWithArguments:(NSArray * _Nonnull)arguments;

/**
 Create request with parsed data

 @param commands NSArray
 @param queries Queries
 @param flags Flags
 @param paths IO paths
 @return CLRequest
 */
+ (instancetype _Nonnull)requestWithCommands:(NSArray * _Nonnull)commands queries:(NSDictionary * _Nullable)queries flags:(id _Nullable)flags paths:(NSArray * _Nullable)paths;

/**
 Create an illegally request

 @param commands NSArray
 @param error NSError
 @return CLRequest
 */
+ (instancetype _Nonnull)illegallyRequestWithCommands:(NSArray * _Nonnull)commands error:(NSError * _Nonnull)error;

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

/**
 Print if flag `verbose`, auto append '\n'

 @param format Format string
 */
- (void)verbose:(NSString * _Nonnull)format, ...;

/**
 Print
 
 @param format Format string
 */
- (void)print:(NSString * _Nonnull)format, ...;

/**
 Print with red color, auto append '\n'

 @param format Format string
 */
- (void)error:(NSString * _Nonnull)format, ...;

/**
 Print with yellow color, auto append '\n'
 
 @param format Format string
 */
- (void)warning:(NSString * _Nonnull)format, ...;

/**
 Print with green color, auto append '\n'
 
 @param format Format string
 */
- (void)success:(NSString * _Nonnull)format, ...;

/**
 Print with light font, auto append '\n'
 
 @param format Format string
 */
- (void)info:(NSString * _Nonnull)format, ...;

@end
