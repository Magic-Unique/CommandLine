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
    static CLFlag *_help = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _help = [[self alloc] initWithKey:@"help"];
        _help.inheritify().setExplain(CLCurrentLanguage.helpExplain);
    });
    return _help;
}

+ (instancetype)verbose {
    static CLFlag *_verbose = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _verbose = [[self alloc] initWithKey:@"verbose"];
        _verbose.inheritify().setExplain(CLCurrentLanguage.verboseExplain);
    });
    return _verbose;
}

+ (instancetype)version {
    static CLFlag *_version = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _version = [[self alloc] initWithKey:@"version"];
        _version.setExplain(CLCurrentLanguage.versionExplain);
    });
    return _version;
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
