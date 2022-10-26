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

- (NSString *)titleWithAbbr:(BOOL)abbr {
    NSString *prefix = abbr ? @"   " : @"";
    NSString *value = self.example?:self.key;
    NSString *muti_tips = [NSString stringWithFormat:@"<%@>", value];
    switch (self.multiType) {
        case CLQueryMultiTypeSeparatedByComma:
            muti_tips = [NSString stringWithFormat:@"<%@1,%@2...>", value, value];
            break;
        case CLQueryMultiTypeMoreKeyValue:
            muti_tips = [NSString stringWithFormat:@"<%@1> ...", value];
            break;
        case CLQueryMultiTypeNone:
        default:
            break;
    }
    if (self.abbr && abbr) {
        prefix = [NSString stringWithFormat:@"-%c|", self.abbr];
    }
    return [NSString stringWithFormat:@"%@--%@ %@", prefix, self.key, muti_tips];
}

- (NSString *)subtitle {
    return self.explain?:@"";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Query key=\"%@\" abbr=\'%c\' %@>: %@", self.key, _abbr, _isOptional?@"optional":@"require", _explain?:@"NO EXPLAIN"];
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

- (CLQuery * _Nonnull (^)(CLQueryMultiType))setMultiType {
    return ^CLQuery *(CLQueryMultiType type) {
        self->_multiType = type;
        return self;
    };
}

- (CLQuery *(^)(NSString *))predicate {
    return ^CLQuery *(NSString *regular) {
        self->_regular = [regular copy];
        return self;
    };
}

@end

