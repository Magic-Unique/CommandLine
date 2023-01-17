//
//  CLType.h
//  CommandLineDemo
//
//  Created by 冷秋 on 2022/10/20.
//  Copyright © 2022 Magic-Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CLConvertType(type) NS_INLINE type CLConvert_##type(NSString *string)
#define CLConvertClass(class, type) typedef class *type; CLConvertType(type)

CLConvertClass(NSString, CLString) { return string; }
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

#define CLTrue  [_CLBool _YES]
#define CLFalse [_CLBool _false]

typedef _CLBool *CLBool;
CLConvertType(CLBool) { return string ? CLTrue : CLFalse; }
