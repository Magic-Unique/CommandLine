//
//  CLFlag.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLExplain.h"

@interface CLFlag : CLExplain

@property (nonatomic, strong, readonly, nonnull) NSString *key;

@property (nonatomic, assign, readonly) char abbr;

@property (nonatomic, strong, readonly, nullable) NSString *explain;

@property (nonatomic, assign, readonly, getter=isPredefine) BOOL predefine;

+ (instancetype _Nonnull)help;
+ (instancetype _Nonnull)verbose;
+ (instancetype _Nonnull)version;
+ (instancetype _Nonnull)silent;
+ (instancetype _Nonnull)noANSI;

@end

@interface CLFlag (Definer)

/**
 Set abbr
 */
@property (nonatomic, readonly, nonnull) CLFlag * _Nonnull (^setAbbr)(char abbr);

/**
 Set description
 */
@property (nonatomic, readonly, nonnull) CLFlag * _Nonnull (^setExplain)(NSString * _Nonnull explain);

/**
 Inherit to subcommand
 */
@property (nonatomic, readonly, nonnull) CLFlag * _Nonnull (^inheritify)(void);

- (instancetype _Nonnull)initWithKey:(NSString * _Nonnull)key;

@end
