//
//  CLResponse.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLResponse.h"

@implementation CLResponse

- (BOOL)isFailed {
    return self.error ? YES : NO;
}

+ (instancetype)error:(NSError *)error {
    CLResponse *response = [CLResponse new];
    response->_error = error;
    return response;
}

+ (instancetype)errorWithDescription:(NSString *)description {
    return [self error:[NSError errorWithDomain:@"com.unique.commandline" code:EXIT_FAILURE userInfo:@{NSLocalizedDescriptionKey:description}]];
}

+ (instancetype)succeed:(NSDictionary *)userInfo {
    CLResponse *response = [CLResponse new];
    response->_userInfo = userInfo;
    return response;
}

@end
