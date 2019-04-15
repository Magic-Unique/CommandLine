//
//  CLResponse.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLResponse : NSObject

@property (nonatomic, strong, readonly, nullable) NSDictionary *userInfo;

@property (nonatomic, strong, readonly, nullable) NSError *error;

@property (nonatomic, assign, readonly) BOOL isFailed;

/**
 Create a failed response

 @param error NSError
 @return CLResponse
 */
+ (instancetype _Nonnull)error:(NSError * _Nullable)error;

/**
 Create a succeed response

 @param userInfo NSDictionary
 @return CLResponse
 */
+ (instancetype _Nonnull)succeed:(NSDictionary * _Nullable)userInfo;

@end
