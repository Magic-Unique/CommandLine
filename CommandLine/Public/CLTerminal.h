//
//  CLTerminal.h
//  CommandLineDemo
//
//  Created by 冷秋 on 2018/6/3.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Is debug in Xcode
 
 @return BOOL
 */
FOUNDATION_EXTERN BOOL CLProcessIsAttached(void);


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
 Get current directory

 @return NSString
 */
FOUNDATION_EXTERN NSString * _Nonnull CLCurrentDirectory(void);


/**
 Change current directory

 @param directory The new directory
 @return int
 */
FOUNDATION_EXTERN int CLChangeCurrentDirectory(NSString * _Nullable directory);
