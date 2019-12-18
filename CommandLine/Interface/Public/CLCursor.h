//
//  CLCursor.h
//  CommandLine
//
//  Created by 冷秋 on 2019/12/14.
//

#import <Foundation/Foundation.h>

@interface CLCursor : NSObject

+ (void)up;
+ (void)up:(NSUInteger)steps;

+ (void)down;
+ (void)down:(NSUInteger)steps;

+ (void)left;
+ (void)left:(NSUInteger)steps;

+ (void)right;
+ (void)right:(NSUInteger)steps;

+ (void)cleanAfter;

+ (void)hide;

+ (void)show;

+ (void)storagePosition;

+ (void)recoverPosition;

+ (void)clear;

@end
