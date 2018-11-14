//
//  CLQuery.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLExplain.h"


@interface CLQuery : CLExplain

@property (nonatomic, strong, readonly) NSString *key;

@property (nonatomic, assign, readonly) char abbr;

@property (nonatomic, strong, readonly) NSString *explain;

@property (nonatomic, assign, readonly) BOOL isOptional;

@property (nonatomic, strong, readonly) NSString *regular;

@property (nonatomic, assign, readonly) BOOL isMultiable;

@property (nonatomic, strong, readonly) NSString *example;

@property (nonatomic, strong, readonly) id defaultValue;

@end





@interface CLQuery (Definer)

@property (nonatomic, readonly) CLQuery *(^require)(void);
@property (nonatomic, readonly) CLQuery *(^optional)(void);

@property (nonatomic, readonly) CLQuery *(^setAbbr)(char abbr);
@property (nonatomic, readonly) CLQuery *(^setExplain)(NSString *explain);
@property (nonatomic, readonly) CLQuery *(^setDefaultValue)(id defaultValue);
@property (nonatomic, readonly) CLQuery *(^setExample)(NSString *example);

@property (nonatomic, readonly) CLQuery *(^asString)(void);
@property (nonatomic, readonly) CLQuery *(^asPath)(void);
@property (nonatomic, readonly) CLQuery *(^asNumber)(void);
@property (nonatomic, readonly) CLQuery *(^multify)(void);
@property (nonatomic, readonly) CLQuery *(^predicate)(NSString *regular);

- (instancetype)initWithKey:(NSString *)key;

@end




@interface CLQuery (Predicate)

- (BOOL)predicateForString:(NSString *)string;

@end

