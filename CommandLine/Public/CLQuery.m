//
//  CLQuery.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLQuery.h"
#import "NSString+CommandLine.h"

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
    NSString *muti_tips = self.isMultiable ? @" ..." : @"";
    if (self.abbr) {
        prefix = [NSString stringWithFormat:@"-%c|", self.abbr];
    }
    return [NSString stringWithFormat:@"%@--%@ <%@>%@", prefix, self.key, self.example?self.example:self.key, muti_tips];
}

- (NSString *)subtitle {
    return self.explain?:@"";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Query key=\"%@\" abbr=\'%c\' %@>: %@", _key, _abbr, _isOptional?@"optional":@"require", _explain?:@"NO EXPLAIN"];
}

@end

@implementation CLQuery (Predicate)

- (BOOL)predicateForString:(NSString *)string {
    if (self.regular.length) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.regular];
        return [predicate evaluateWithObject:string];
    } else {
        return YES;
    }
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

- (CLQuery *(^)(id))setDefaultValue {
    return ^CLQuery *(id defaultValue) {
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

- (CLQuery *(^)(void))asString {
    return ^CLQuery *() {
        self->_regular = nil;
        return self;
    };
}

- (CLQuery *(^)(void))asPath {
    return ^CLQuery *() {
        self->_regular = CLRegularPath;
        return self;
    };
}

- (CLQuery *(^)(void))asNumber {
    return ^CLQuery *() {
        self->_regular = CLRegularNumber;
        return self;
    };
}

- (CLQuery *(^)(void))multify {
    return ^CLQuery *() {
        self->_isMultiable = YES;
        return self;
    };
}

- (CLQuery *(^)(NSString *))predicate {
    return ^CLQuery *(NSString *regular) {
        self->_regular = [regular copy];
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

