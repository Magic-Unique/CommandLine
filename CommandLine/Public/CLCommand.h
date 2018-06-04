//
//  CLCommand.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLQuery.h"
#import "CLFlag.h"
#import "CLIOPath.h"
#import "CLRequest.h"
#import "CLResponse.h"

@class CLCommand, CLRequest, CLResponse;




typedef void(^CLCommandDefining)(CLCommand *command);

typedef CLResponse *(^CLCommandTask)(CLCommand *command, CLRequest *request);






@interface CLCommand : CLExplain

/**
 Set the tool's explain. 设置此命令行的描述

 @param explain NSString
 */
+ (void)setExplain:(NSString *)explain;

/**
 Set the tool's version. 设置此命令行的版本

 @param version NSString
 */
+ (void)setVersion:(NSString *)version;

/**
 Get the tool's version. 取此命令行的版本

 @return NSString
 */
+ (NSString *)version;

/**
 Set the task without any subcommand. 设置无子命令的时候要执行的任务

 @param defaultTask Default task.
 */
+ (void)setDefaultTask:(CLCommandTask)defaultTask;

/**
 Handle a request. You need defined all commands before calling the method. 处理请求。执行之前请定义完毕所有命令。

 @param request CLRequest
 @return CLResponse
 */
+ (CLResponse *)handleRequest:(CLRequest *)request;





@property (nonatomic, readonly) NSString *command;

@property (nonatomic, readonly) NSString *explain;

@property (nonatomic, readonly) NSDictionary<NSString *, CLCommand *> *subcommands;

@property (nonatomic, readonly) NSDictionary<NSString *, CLQuery *> *queries;

@property (nonatomic, readonly) NSDictionary<NSString *, CLFlag *> *flags;

@property (nonatomic, readonly) NSArray *ioPaths;

@property (nonatomic, weak, readonly) CLCommand *supercommand;

@property (nonatomic, readonly) CLCommandTask task;

+ (instancetype)sharedCommand;

+ (instancetype)defineCommand:(NSString *)command
                      explain:(NSString *)explain
                     onCreate:(CLCommandDefining)onCreate
                    onRequest:(CLCommandTask)onRequest;

- (instancetype)defineSubcommand:(NSString *)command
                         explain:(NSString *)explain
                        onCreate:(CLCommandDefining)onCreate
                       onRequest:(CLCommandTask)onRequest;

@property (nonatomic, readonly) CLQuery *(^setQuery)(NSString *key);

@property (nonatomic, readonly) CLFlag *(^setFlag)(NSString *key);

@property (nonatomic, readonly) CLIOPath *(^addRequirePath)(NSString *key);

@property (nonatomic, readonly) CLIOPath *(^addOptionalPath)(NSString *key);

@end
