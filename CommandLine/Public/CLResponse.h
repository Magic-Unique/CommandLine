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

@property (nonatomic, assign, readonly) BOOL needHelp;

+ (instancetype _Nonnull)error:(NSError * _Nullable)error;
+ (instancetype _Nonnull)errorWithDescription:(NSString * _Nullable)description;

+ (instancetype _Nonnull)succeed:(NSDictionary * _Nullable)userInfo;

@end

@interface CLResponse (Help)


/**
 Return it in handle block, Command Line will print helping information.

 @return CLResponse
 */
+ (instancetype _Nonnull)helpingResponse;

@end
