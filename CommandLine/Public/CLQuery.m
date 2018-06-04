//
//  CLQuery.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLQuery.h"

@implementation CLQuery

- (void)setKey:(NSString *)key {
    _key = key;
}

- (void)setAbbr:(char)abbr {
    _abbr = abbr;
}

- (void)setIsOptional:(BOOL)isOptional {
    _isOptional = isOptional;
}

- (void)setExplain:(NSString *)explain {
    _explain = explain;
}

- (void)setDefaultValue:(NSString *)defaultValue {
    _defaultValue = defaultValue;
}

- (void)setExample:(NSString *)example {
    _example = example;
}

- (NSString *)title {
    NSString *prefix = @"   ";
    if (self.abbr) {
        prefix = [NSString stringWithFormat:@"-%c|", self.abbr];
    }
    return [NSString stringWithFormat:@"%@--%@ <%@>", prefix, self.key, self.example?:self.key];
}

- (NSString *)subtitle {
    return self.explain?:@"";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Query key=\"%@\" abbr=\'%c\' %@>: %@", _key, _abbr, _isOptional?@"optional":@"require", _explain?:@"NO EXPLAIN"];
}

@end

@implementation CLQuery (Definer)

- (CLQuery *(^)(NSString *))setKey {
    return ^CLQuery *(NSString *key) {
        self.key = key;
        return self;
    };
}

- (CLQuery *(^)(char))setAbbr {
    return ^CLQuery *(char abbr) {
        self.abbr = abbr;
        return self;
    };
}

- (CLQuery *(^)(void))require {
    return ^CLQuery *(void) {
        self.isOptional = NO;
        return self;
    };
}

- (CLQuery *(^)(void))optional {
    return ^CLQuery *(void) {
        self.isOptional = YES;
        return self;
    };
}

- (CLQuery *(^)(NSString *))setExplain {
    return ^CLQuery *(NSString *explain) {
        self.explain = explain;
        return self;
    };
}

- (CLQuery *(^)(NSString *))setDefaultValue {
    return ^CLQuery *(NSString *defaultValue) {
        self.defaultValue = defaultValue;
        return self;
    };
}

- (CLQuery *(^)(NSString *))setExample {
    return ^CLQuery *(NSString *example) {
        self.example = example;
        return self;
    };
}

- (instancetype)initWithKey:(NSString *)key {
    self = [super init];
    if (self) {
        self.key = key;
    }
    return self;
}

@end

