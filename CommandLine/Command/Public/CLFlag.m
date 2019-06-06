//
//  CLFlag.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLFlag.h"
#import "CLLanguage+Private.h"

@implementation CLFlag

- (void)setKey:(NSString *)key {
    _key = key;
}

- (void)setAbbr:(char)abbr {
    _abbr = abbr;
}

- (void)setExplain:(NSString *)explain {
    _explain = explain;
}

- (NSString *)title {
    NSString *prefix = @"   ";
    if (self.abbr) {
        prefix = [NSString stringWithFormat:@"-%c|", self.abbr];
    } else if (self.isPredefine) {
        prefix = @"";
    }
    return [NSString stringWithFormat:@"%@--%@", prefix, self.key];
}

- (NSString *)subtitle {
    return self.explain?:@"";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<CLFlag key=\"%@\" abbr=\'%c\'>: %@", _key, _abbr, _explain];
}

+ (instancetype)help {
    static CLFlag *flag = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        flag = [[self alloc] initWithKey:@"help"];
        flag->_predefine = YES;
        flag.inheritify().setExplain(CLCurrentLanguage.helpExplain);
    });
    return flag;
}

+ (instancetype)verbose {
    static CLFlag *flag = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        flag = [[self alloc] initWithKey:@"verbose"];
        flag->_predefine = YES;
        flag.inheritify().setExplain(CLCurrentLanguage.verboseExplain);
    });
    return flag;
}

+ (instancetype)version {
    static CLFlag *flag = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        flag = [[self alloc] initWithKey:@"version"];
        flag->_predefine = YES;
        flag.setExplain(CLCurrentLanguage.versionExplain);
    });
    return flag;
}

+ (instancetype)silent {
    static CLFlag *flag = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        flag = [[self alloc] initWithKey:@"silent"];
        flag->_predefine = YES;
        flag.inheritify().setExplain(CLCurrentLanguage.silentExplain);
    });
    return flag;
}

+ (instancetype)noANSI {
    static CLFlag *flag = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        flag = [[self alloc] initWithKey:@"no-ansi"];
        flag->_predefine = YES;
        flag.inheritify().setExplain(CLCurrentLanguage.noANSIExplain);
    });
    return flag;
}

@end

@implementation CLFlag (Definer)

- (instancetype)initWithKey:(NSString *)key {
    self = [super init];
    if (self) {
        self.key = key;
    }
    return self;
}

- (CLFlag *(^)(char))setAbbr {
    return ^CLFlag *(char abbr) {
        self.abbr = abbr;
        return self;
    };
}

- (CLFlag *(^)(NSString *))setExplain {
    return ^CLFlag *(NSString *explain) {
        self.explain = explain;
        return self;
    };
}

@end
