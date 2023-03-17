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
CLConvertType(BOOL) { return string ? YES : NO; }
CLConvertType(_Bool) { return string ? YES : NO; }
