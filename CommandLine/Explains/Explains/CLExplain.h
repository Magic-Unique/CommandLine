//
//  CLExplain.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/20.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLExplain : NSObject

@property (nonatomic, copy, readonly, nonnull) NSString *key;

@property (nonatomic, copy, readonly, nullable) NSString *subtitle;

@property (nonatomic, assign, readonly) BOOL isInheritable;

- (instancetype _Nonnull)initWithKey:(NSString * _Nonnull)key index:(NSUInteger)index;

- (NSString * _Nonnull)titleWithAbbr:(BOOL)abbr;

@end




@interface CLExplain (Definer)

@property (nonatomic, readonly, nonnull) CLExplain * _Nonnull (^inheritify)(void);

@end

