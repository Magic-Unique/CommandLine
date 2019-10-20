//
//  CLWorkDirectory.h
//  CommandLine
//
//  Created by 冷秋 on 2019/6/6.
//

#import <Foundation/Foundation.h>

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
