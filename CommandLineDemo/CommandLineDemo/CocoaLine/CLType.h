//
//  CLType.h
//  CommandLineDemo
//
//  Created by 吴双 on 2022/10/20.
//  Copyright © 2022 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@class _CLBool;

#define CLConvertType(type) NS_INLINE type CLConvert_##type(NSString *string)

typedef NSString *CLString;
CLConvertType(CLString) { return string; }
CLConvertType(NSInteger) { return string.integerValue; }
CLConvertType(NSUInteger) { return (NSUInteger)string.integerValue; }
CLConvertType(int) { return string.intValue; }
CLConvertType(double) { return string.doubleValue; }
CLConvertType(float) { return string.floatValue; }
CLConvertType(char) { return string.length ? 0 : string.UTF8String[0]; }


@interface _CLBool : NSObject

+ (instancetype)_YES;
+ (instancetype)_true;
+ (instancetype)_NO;
+ (instancetype)_false;

@property (nonatomic, assign, readonly) BOOL isYES;
@property (nonatomic, assign, readonly) BOOL isTrue;

@end

typedef _CLBool *CLBool;
CLConvertType(CLBool) { return string ? [_CLBool _true] : [_CLBool _false]; }
