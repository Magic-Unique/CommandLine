//
//  CLCommand.h
//  CommandLineDemo
//
//  Created by 冷秋 on 2022/8/31.
//  Copyright © 2022 Magic-Unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLRunner.h"
#import "metamacros.h"
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



@protocol CLRunnable <NSObject>

@optional
- (int)main;

@end



@interface CLCommandConfiguration : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *note;

@property (nonatomic, strong) NSString *version;

@end


@interface CLCommand : NSObject <CLRunnable>

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
(void)_CL_CONCAT_3(_, __CLOPT, index, name):(CLOptionInfo *)name {\
    [name setType:@#type]; \
    metamacro_foreach_cxt(_CL_ATTRS,,name,nonnull,##__VA_ARGS__) \
} \
- (type)name { return CLConvert_##type([self.runner __valueForTag:index]); } \
- (void)_CL_CONCAT_3(_, __Init, index, name):(CLRunner *)runner { \
    name = CLConvert_##type([runner __valueForTag:index]); \
} type name;

#define command_option(type, name, ...) _CL_OPTION(__COUNTER__, type, name, ##__VA_ARGS__)

#pragma mark - Argument

#define _CL_ARGUMENT(index, type, name, ...) \
(void)_CL_CONCAT_3(_, __CLARG, index, name):(CLArgumentInfo *)name { \
    [name setType:@#type]; \
    metamacro_foreach_cxt(_CL_ATTRS,,name,self,##__VA_ARGS__) \
} \
- (type)name { return CLConvert_##type([self.runner __valueForTag:index]); } \
- (void)_CL_CONCAT_3(_, __Init, index, name):(CLRunner *)runner { \
    name = CLConvert_##type([runner __valueForTag:index]); \
} type name;

#define command_argument(type, name, ...) _CL_ARGUMENT(__COUNTER__, type, name, ##__VA_ARGS__)

#pragma mark - Array

#define _CL_ARRAY_MAP(array, statement) NSArrayWithMap((array), ^id(id obj) { return (statement); })

#define _CL_ARRAY(index, type, name, ...) \
(void)_CL_CONCAT_3(_, __CLARY, index, name):(CLArgumentInfo *)name { \
    [name setType:@#type]; \
    metamacro_foreach_cxt(_CL_ATTRS,,name,self,##__VA_ARGS__) \
} \
- (NSArray<type> *)name { \
    return _CL_ARRAY_MAP([self.runner __valueForTag:index], CLConvert_##type(obj)); \
} \
- (void)_CL_CONCAT_3(_, __Init, index, name):(CLRunner *)runner { \
    name = _CL_ARRAY_MAP([runner __valueForTag:index], CLConvert_##type(obj)); \
} NSArray<type> *name; + (void)_This_command_should_not_contains_two_array_input {};

#define command_arguments(type, name, ...) _CL_ARRAY(__COUNTER__, type, name, ##__VA_ARGS__)

#pragma mark - Command

#define _CL_EACH_SUBCMD(INDEX, CTX, VAR) [VAR class],
#define command_subcommands(...) \
(void)This_command_should_contain_one_of_subcmd_or_main_function {} \
+ (NSArray<Class> *)subcommands {\
    return @[metamacro_foreach_cxt(_CL_EACH_SUBCMD,,,##__VA_ARGS__)]; \
}

#define command_main() \
(void)This_command_should_contain_one_of_subcmd_or_main_function {} \
- (int)main

#define command_configuration() \
(void)__configuration:(CLCommandConfiguration *)configuration

/*
 
 command_option(Other, name)      key-value
 command_option(CLBool, name)     key
 command_arguments(Other, name)   [value]
 input_value(Other, name)       value
 */
