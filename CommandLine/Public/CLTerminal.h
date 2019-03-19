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
FOUNDATION_EXTERN int CLSystem(NSString *format, ...);


/**
 Print

 @param format NSString
 @param ... arguments
 */
FOUNDATION_EXTERN void CLPrintf(NSString *format, ...);


/**
 launch a command

 @param launchDirectory Current work directory, Pass in nil to use default value.
 @param ... NSStrings or NSArray
 @return NSString. Return nil if exit with FAILURE code.
 */
FOUNDATION_EXTERN NSString *CLLaunch(NSString *launchDirectory, ...) NS_REQUIRES_NIL_TERMINATION;


/**
 Get current directory

 @return NSString
 */
FOUNDATION_EXTERN NSString *CLCurrentDirectory(void);


/**
 Change current directory

 @param directory The new directory
 @return int
 */
FOUNDATION_EXTERN int CLChangeCurrentDirectory(NSString *directory);
