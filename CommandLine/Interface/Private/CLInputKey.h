//
//  CLInputKey.h
//  CommandLine
//
//  Created by 冷秋 on 2019/10/30.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CLKey) {
    CLKeyNone       = 0,
    CLKeyReturn     = 10,
    CLKey_q         = 113,
    CLKeyUp         = -1,
    CLKeyDown       = -2,
    CLKeyRight      = -3,
    CLKeyLeft       = -4,
};

@interface CLInputKey : NSObject

@property (nonatomic, assign, readonly) CLKey key;

+ (instancetype)getKey;

+ (instancetype)getKeyWithFilter:(BOOL (^)(CLInputKey *key))filter;

+ (instancetype)getSelectorKey:(BOOL)multiSelect;

@end
