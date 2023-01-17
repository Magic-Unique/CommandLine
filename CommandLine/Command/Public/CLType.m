//
//  CLType.m
//  CommandLineDemo
//
//  Created by 冷秋 on 2022/10/20.
//  Copyright © 2022 Magic-Unique. All rights reserved.
//

#import "CLType.h"

@implementation _CLBool

+ (instancetype)__sharedBool {
    static _CLBool *_sharedBool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedBool = [[self alloc] init];
    });
    return _sharedBool;
}

+ (instancetype)_YES { return [self __sharedBool]; }
+ (instancetype)_NO { return nil; }
+ (instancetype)_true { return [self __sharedBool]; }
+ (instancetype)_false { return nil; }

- (BOOL)isYES { return YES; }
- (BOOL)isTrue { return YES; }

@end
