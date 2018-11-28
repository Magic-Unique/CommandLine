//
//  CLFlag.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLExplain.h"

@interface CLFlag : CLExplain

@property (nonatomic, strong, readonly) NSString *key;

@property (nonatomic, assign, readonly) char abbr;

@property (nonatomic, strong, readonly) NSString *explain;

+ (instancetype)help;
+ (instancetype)verbose;
+ (instancetype)version;

@end

@interface CLFlag (Definer)

@property (nonatomic, readonly) CLFlag *(^setAbbr)(char abbr);

@property (nonatomic, readonly) CLFlag *(^setExplain)(NSString *explain);

@property (nonatomic, readonly) CLFlag *(^inheritify)(void);

- (instancetype)initWithKey:(NSString *)key;

@end
