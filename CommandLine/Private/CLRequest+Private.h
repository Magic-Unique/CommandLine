//
//  CLRequest+Private.h
//  CommandLine
//
//  Created by 吴双 on 2019/4/13.
//

#import "CLRequest.h"

@interface CLRequest (Private)

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

@end

@interface CLRequest (Stack)

+ (BOOL)verbose;

+ (void)setVerbose:(BOOL)verbose;

@end
