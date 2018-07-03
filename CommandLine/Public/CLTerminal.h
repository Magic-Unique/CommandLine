//
//  CLTerminal.h
//  CommandLineDemo
//
//  Created by 冷秋 on 2018/6/3.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN int CLSystem(NSString *format, ...);

FOUNDATION_EXTERN void CLPrintf(NSString *format, ...);

FOUNDATION_EXTERN NSString *CLLaunchAt(NSString *directory, NSString *launchPath, ...) NS_REQUIRES_NIL_TERMINATION;

FOUNDATION_EXTERN NSString *CLLaunch(NSString *launchPath, ...) NS_REQUIRES_NIL_TERMINATION;

FOUNDATION_EXTERN NSString *CLCurrentDirectory(void);

FOUNDATION_EXTERN int CLChangeCurrentDirectory(NSString *directory);
