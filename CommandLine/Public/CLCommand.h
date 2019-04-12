//
//  CLCommand.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLExplain.h"

@class CLCommand, CLRequest, CLResponse, CLQuery, CLFlag, CLIOPath;

typedef CLResponse * _Nullable (^CLCommandTask)(CLCommand * _Nonnull command, CLRequest * _Nonnull request);


@interface CLCommand : CLExplain

/**
 Set the tool's version. 设置此命令行的版本

 @param version NSString
 */
+ (void)setVersion:(NSString * _Nonnull)version;

/**
 Get the tool's version. 取此命令行的版本

 @return NSString
 */
+ (NSString * _Nullable)version;

/**
 Handle a request. You need defined all commands before calling the method. 处理请求。执行之前请定义完毕所有命令。

 @param request CLRequest
 @return CLResponse
 */
+ (CLResponse * _Nonnull)handleRequest:(CLRequest * _Nonnull)request;


@property (nonatomic, readonly, nonnull) NSString *command;

@property (nonatomic, strong, nullable) NSString *explain;

@property (nonatomic, readonly, nonnull) NSDictionary<NSString *, CLCommand *> *subcommands;

@property (nonatomic, readonly, nullable) CLCommand *forwardingSubcommand;

@property (nonatomic, readonly, nonnull) NSDictionary<NSString *, CLQuery *> *queries;

@property (nonatomic, readonly, nonnull) NSDictionary<NSString *, CLFlag *> *flags;

@property (nonatomic, readonly, nonnull) NSArray<CLIOPath *> *ioPaths;

@property (nonatomic, weak, readonly, nullable) CLCommand *supercommand;
@property (nonatomic, readonly, nonnull) NSArray<NSString *> *commandPath;
@property (nonatomic, readonly, nonnull) NSArray<CLCommand *> *commandNodes;

/** ignore invalid key, default is NO, will inherit subcommands */
@property (nonatomic, assign) BOOL allowInvalidKeys;

@property (nonatomic, readonly, nullable) CLCommandTask task;

- (instancetype _Nonnull)defineSubcommand:(NSString * _Nonnull)command;
- (instancetype _Nonnull)defineForwardingSubcommand:(NSString * _Nonnull)command;
- (void)onHandlerRequest:(CLCommandTask _Nonnull)onHandler;

+ (instancetype _Nonnull)main;

+ (void)defineCommandsForClass:(NSString * _Nonnull)className metaSelectorPrefix:(NSString * _Nonnull)prefix;

@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^setQuery)(NSString * _Nonnull key);

@property (nonatomic, readonly, nonnull) CLFlag * _Nonnull (^setFlag)(NSString * _Nonnull key);

@property (nonatomic, readonly, nonnull) CLIOPath * _Nonnull (^addRequirePath)(NSString * _Nonnull key);

@property (nonatomic, readonly, nonnull) CLIOPath * _Nonnull (^addOptionalPath)(NSString * _Nonnull key);

@end
