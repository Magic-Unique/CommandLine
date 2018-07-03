//
//  CLRequest.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLCommand;

@interface CLRequest : NSObject

@property (nonatomic, strong, readonly) NSArray *commands;

@property (nonatomic, strong, readonly) NSDictionary *queries;

@property (nonatomic, strong, readonly) NSSet *flags;

@property (nonatomic, strong, readonly) NSArray *paths;

@property (nonatomic, strong, readonly) CLCommand *command;

+ (instancetype)request;

+ (instancetype)requestWithArgc:(int)argc argv:(const char *[])argv;

+ (instancetype)requestWithArguments:(NSArray *)arguments;

+ (instancetype)requestWithCommands:(NSArray *)commands queries:(NSDictionary *)queries flags:(id)flags paths:(NSArray *)paths;

- (NSString *)stringForQuery:(NSString *)query;

- (NSString *)pathForQuery:(NSString *)query;

- (NSInteger)integerValueForQuery:(NSString *)query;

- (BOOL)flag:(NSString *)flag;

- (NSString *)pathForIndex:(NSUInteger)index;

- (void)verbose:(NSString *)format, ...;

- (void)print:(NSString *)format, ...;

- (void)error:(NSString *)format, ...;

- (void)warning:(NSString *)format, ...;

- (void)success:(NSString *)format, ...;

- (void)info:(NSString *)format, ...;

@end
