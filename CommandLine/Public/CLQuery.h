//
//  CLQuery.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLExplain.h"


@interface CLQuery : CLExplain

@property (nonatomic, strong, readonly, nonnull) NSString *key;

@property (nonatomic, assign, readonly) char abbr;

@property (nonatomic, strong, readonly, nullable) NSString *explain;

@property (nonatomic, assign, readonly) BOOL isOptional;

@property (nonatomic, strong, readonly, nullable) NSString *regular;

@property (nonatomic, assign, readonly) BOOL isMultiable;

@property (nonatomic, strong, readonly, nullable) NSString *example;

@property (nonatomic, strong, readonly, nullable) id defaultValue;

@end





@interface CLQuery (Definer)

@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^require)(void);
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^optional)(void);

@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^setAbbr)(char abbr);
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^setExplain)(NSString * _Nonnull explain);
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^setDefaultValue)(id _Nonnull defaultValue);
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^setExample)(NSString * _Nonnull example);

@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^asString)(void);
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^asPath)(void);
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^asNumber)(void);
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^multify)(void);
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^predicate)(NSString * _Nonnull regular);

@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^inheritify)(void);

- (instancetype _Nonnull)initWithKey:(NSString * _Nonnull)key;

@end




@interface CLQuery (Predicate)

- (BOOL)predicateForString:(NSString * _Nonnull)string;

@end

