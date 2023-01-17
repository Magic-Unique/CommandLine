//
//  CLCommand.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLExplain.h"

@class CLCommand, CLProcess, CLQuery, CLFlag, CLIOPath;

/**
 Command handler task

 @param command CLCommand
 @param process CLProcess
 @return int
 */
typedef int (^CLCommandTask)(CLCommand * _Nonnull command, CLProcess * _Nonnull process);

typedef NS_ENUM(NSUInteger, CLSortType) {
    CLSortTypeByName,               //  Sort by name, default.
    CLSortTypeByAddingQueue,        //  First add, first print.
};


@interface CLCommand : CLExplain

/**
 Root command

 @return CLCommand
 */
+ (instancetype _Nonnull)mainCommand;

/**
 Root command, Use +[CLCommand mainCommand]
 
 @return CLCommand
 */
+ (instancetype _Nonnull)main __deprecated_msg("Deprecated. Use +[CLCommand mainCommand]");

@property (class, nonatomic, assign) CLSortType parametersSortType;

/**
 Define commands use meta class message.
 
 You can define class in some meta class messages, and make those message has the same prefix. Such as:
 + [CLCommand __init_pod], + [CLCommand __init_repo], + [CLCommand __init_spec]...
 And call this method before handler process, all command will be defined batchly.

 @param className Class,
 @param prefix Prefix of meta message
 */
+ (void)defineCommandsForClass:(NSString * _Nonnull)className metaSelectorPrefix:(NSString * _Nonnull)prefix;


/**
 Handle arguments and process them using a task.

 @return int
 */
+ (int)process;

/**
 Ignore invalid key, default is NO, will inherit subcommands
 */
@property (nonatomic, assign) BOOL allowInvalidKeys;

/**
 Description of this command.
 
 It will be used in help.
 */
@property (nonatomic, strong, nullable) NSString *explain;

/**
 Define a subcommand.

 @param command Subcommand name
 @return Subcommand
 */
- (instancetype _Nonnull)defineSubcommand:(NSString * _Nonnull)command;

/**
 Define a forwarding subcommand.

 @param command Subcommand name
 @return Subcommand
 */
- (instancetype _Nonnull)defineForwardingSubcommand:(NSString * _Nonnull)command;

/**
 Make handler task

 @param handler Handler task
 */
- (void)handleProcess:(CLCommandTask _Nonnull)handler;


/**
 Command name.
 */
@property (nonatomic, readonly, nonnull) NSString *name;

/**
 All defined subcommands.
 
 The key is command's name, the value is command.
 */
@property (nonatomic, readonly, nonnull) NSDictionary<NSString *, CLCommand *> *subcommands;

@property (nonatomic, readonly, nullable) CLCommand *forwardingSubcommand;

/**
 All added queries
 
 The key is query's key, the value is query.
 */
@property (nonatomic, readonly, nonnull) NSDictionary<NSString *, CLQuery *> *queries;

/**
 All flags, contains customFlags and predefineFlags
 
 The key is flag's key, the value is flag.
 */
@property (nonatomic, readonly, nonnull) NSDictionary<NSString *, CLFlag *> *flags;

/**
 All custom flags
 
 The key is flag's key, the value is flag.
 */
@property (nonatomic, readonly, nonnull) NSDictionary<NSString *, CLFlag *> *customFlags;

/**
 All predefined flags, such as: version, verbose, help.
 
 The key is flag's key, the value is flag.
 */
@property (nonatomic, readonly, nonnull) NSDictionary<NSString *, CLFlag *> *predefineFlags;

/**
 Add added IOPaths
 
 The key is IOPath's key, the value is IOPath.
 Required IOPath will before optional IOPath.
 */
@property (nonatomic, readonly, nonnull) NSArray<CLIOPath *> *IOPaths;

/**
 Supercommand
 
 Main command has null supercommand.
 */
@property (nonatomic, weak, readonly, nullable) CLCommand *supercommand;

@property (nonatomic, readonly, nonnull) NSArray<NSString *> *commandPath;

/**
 Version of this command.
 
 If set a value, the flag `--version` will be enable.
 And if user pass `--version`, CommandLine will print this value without task running.
 */
@property (nonatomic, strong, nullable) NSString *version;

/**
 Handler task.
 */
@property (nonatomic, readonly, nullable) CLCommandTask task;

/**
 Add a query with key.
 */
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^setQuery)(NSString * _Nonnull key);

/**
 Add a flag with key.
 */
@property (nonatomic, readonly, nonnull) CLFlag * _Nonnull (^setFlag)(NSString * _Nonnull key);

/**
 Add a required path with key.
 */
@property (nonatomic, readonly, nonnull) CLIOPath * _Nonnull (^addRequirePath)(NSString * _Nonnull key);

/**
 Add a optional path with key.
 */
@property (nonatomic, readonly, nonnull) CLIOPath * _Nonnull (^addOptionalPath)(NSString * _Nonnull key);

@end
