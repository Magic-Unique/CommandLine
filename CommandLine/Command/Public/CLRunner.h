//
//  CLRunner.h
//  CommandLineDemo
//
//  Created by 冷秋 on 2022/8/31.
//  Copyright © 2022 Magic-Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLCommandInfo;

@interface CLRunner : NSObject

@property (nonatomic, strong, readonly) CLCommandInfo *commandInfo;

@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *options;

@property (nonatomic, strong, readonly) NSArray<NSString *> *arguments;

@property (nonatomic, strong, readonly) NSError *error;

- (id)__valueForTag:(NSUInteger)tag;

+ (instancetype)runnerWithCommandInfo:(CLCommandInfo *)commandInfo arguments:(NSMutableArray<NSString *> *)arguments;

@end

