//
//  CLResponse.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLResponse : NSObject

@property (nonatomic, strong, readonly) NSDictionary *userInfo;

@property (nonatomic, strong, readonly) NSError *error;

@property (nonatomic, assign, readonly) BOOL isFailed;

+ (instancetype)error:(NSError *)error;
+ (instancetype)errorWithDescription:(NSString *)description;

+ (instancetype)succeed:(NSDictionary *)userInfo;

@end
