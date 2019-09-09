//
//  CLTerminal.h
//  CommandLineDemo
//
//  Created by 冷秋 on 2018/6/3.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Call system

 @param format NSString
 @param ... arguments
 @return int
 */
FOUNDATION_EXTERN int CLSystem(NSString * _Nonnull format, ...);


/**
 launch a command

 @param launchDirectory Current work directory, Pass in nil to use default value.
 @param ... Command and arguments. Supporting NSStrings or NSArray
 @return NSString. Return nil if exit with FAILURE code.
 */
FOUNDATION_EXTERN NSString * _Nullable CLLaunch(NSString * _Nullable launchDirectory, ...) NS_REQUIRES_NIL_TERMINATION;


/**
 Use CLEnvironment to change CLLaunch environment.
 
 Set value: CLEnvironment[@"key"] = @"value";
 Get value: NSString *value = CLEnvironment[@"key"];
 */
#define CLEnvironment [_CLEnvironment environment]

@interface _CLEnvironment : NSObject
+ (instancetype _Nonnull)environment;
- (void)setObject:(NSString * _Nullable)obj forKeyedSubscript:(NSString * _Nonnull)key;
- (NSString * _Nullable)objectForKeyedSubscript:(NSString * _Nonnull)key;
@end
