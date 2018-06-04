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

@property (nonatomic, strong, readonly) NSString *example;

@property (nonatomic, strong, readonly) NSString *defaultValue;

@end






@interface CLQuery (Definer)

@property (nonatomic, readonly) CLQuery *(^require)(void);
@property (nonatomic, readonly) CLQuery *(^optional)(void);

@property (nonatomic, readonly) CLQuery *(^setAbbr)(char abbr);
@property (nonatomic, readonly) CLQuery *(^setExplain)(NSString *explain);
@property (nonatomic, readonly) CLQuery *(^setDefaultValue)(NSString *defaultValue);
@property (nonatomic, readonly) CLQuery *(^setExample)(NSString *example);

- (instancetype)initWithKey:(NSString *)key;

@end

