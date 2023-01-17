//
//  CLTerminal.h
//  CommandLineDemo
//
//  Created by 冷秋 on 2018/6/3.
//  Copyright © 2023 Magic-Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Is debug in Xcode
 
 @return BOOL
 */
FOUNDATION_EXTERN BOOL CLProcessIsAttached(void);

/// 判断当前进程是否在 Xcode 控制台
FOUNDATION_EXTERN BOOL CLProcessInXcodeConsole(void);


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
