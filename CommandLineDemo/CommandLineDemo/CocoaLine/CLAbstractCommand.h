//
//  CLAbstractCommand.h
//  CommandLineDemo
//
//  Created by 吴双 on 2022/8/31.
//  Copyright © 2022 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLRunner.h"
#import <libextobjc/EXTScope.h>
#import "CLCommandInfo.h"
#import "CLType.h"

NS_INLINE NSArray *NSArrayWithMap(NSArray *array, id(^mapBlock)(id obj)) {
    NSMutableArray *newarray = [NSMutableArray arrayWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id ret = mapBlock(obj);
        if (ret) {
            [newarray addObject:ret];
        }
    }];
    return [newarray copy];
}



@protocol CLParsable <NSObject>

+ (NSString *)name;

+ (NSString *)note;

+ (NSArray<Class> *)subcommands;

@end





@protocol CLRunnable <NSObject>

@optional
- (int)main;

@end




@interface CLAbstractCommand : NSObject <CLParsable, CLRunnable>

@property (nonatomic, strong, readonly) CLRunner *runner;

+ (int)main;
+ (int)main:(int)argc argv:(const char *[])argv;
+ (int)main:(NSArray<NSString *> *)arguments;

@end

#define CLRunnableMain(cmd) \
int main(int argc, const char * argv[]) { \
    int ret = 0; @autoreleasepool { ret = [cmd main]; } return ret; \
}



#define _CL_CONCAT_4(sep, A, B, C, D)    A##sep##B##sep##C##sep##D
#define _CL_CONCAT_3(sep, A, B, C)       A##sep##B##sep##C
#define _CL_CONCAT_2(sep, A, B)          A##sep##B##sep
#define _CL_ATTRS(INDEX, CTX, VAR)  __unused __auto_type _var_##INDEX = (CTX.VAR);

#pragma mark - Option

#define _CL_OPTION(index, type, name, ...) \
(type)name { return CLConvert_##type([self.runner __valueForTag:index]); } \
- (void)_CL_CONCAT_3(_, __Init, index, name):(CLRunner *)runner { \
    name = CLConvert_##type([runner __valueForTag:index]); \
} type name; \
+ (void)_CL_CONCAT_3(_, __CLOPT, index, name):(CLOptionInfo *)name {\
    [name setType:@#type]; \
    metamacro_foreach_cxt(_CL_ATTRS,,name,self,##__VA_ARGS__) \
}

#define input_option(type, name, ...) _CL_OPTION(__COUNTER__, type, name, ##__VA_ARGS__)

#pragma mark - Argument

#define _CL_ARGUMENT(index, type, name, ...) \
(type)name { return CLConvert_##type([self.runner __valueForTag:index]); } \
- (void)_CL_CONCAT_3(_, __Init, index, name):(CLRunner *)runner { \
    name = CLConvert_##type([runner __valueForTag:index]); \
} type name; \
+ (void)_CL_CONCAT_3(_, __CLARG, index, name):(CLArgumentInfo *)name { \
    [name setType:@#type]; \
    metamacro_foreach_cxt(_CL_ATTRS,,name,self,##__VA_ARGS__) \
}

#define input_argument(type, name, ...) _CL_ARGUMENT(__COUNTER__, type, name, ##__VA_ARGS__)

#pragma mark - Array

#define _CL_ARRAY_MAP(array, statement) NSArrayWithMap((array), ^id(id obj) { return (statement); })

#define _CL_ARRAY(index, type, name, ...) \
(NSArray<type> *)name { \
    return _CL_ARRAY_MAP([self.runner __valueForTag:index], CLConvert_##type(obj)); \
} \
- (void)_CL_CONCAT_3(_, __Init, index, name):(CLRunner *)runner { \
    name = _CL_ARRAY_MAP([runner __valueForTag:index], CLConvert_##type(obj)); \
} NSArray<type> *name; + (void)_This_command_should_not_contains_two_array_input {}; \
+ (void)_CL_CONCAT_3(_, __CLARY, index, name):(CLArgumentInfo *)name { \
    [name setType:@#type]; \
    metamacro_foreach_cxt(_CL_ATTRS,,name,self,##__VA_ARGS__) \
}

#define input_array(type, name, ...) _CL_ARRAY(__COUNTER__, type, name, ##__VA_ARGS__)

#pragma mark - Command

#define command_name(n) (NSString *)name { return @#n; }

#define command_note(n) (NSString *)note { return n; }

#define _CL_EACH_SUBCMD(INDEX, CTX, VAR) [VAR class],
#define command_subcmd(...) (NSArray<Class> *)subcommands {\
    return @[metamacro_foreach_cxt(_CL_EACH_SUBCMD,,,##__VA_ARGS__)]; \
}

#define command_main() (int)main

/*
 
 input_option(Other, name)      key-value
 input_option(CLBool, name)     key
 input_arguments(Other, name)   [value]
 input_value(Other, name)       value
 */
