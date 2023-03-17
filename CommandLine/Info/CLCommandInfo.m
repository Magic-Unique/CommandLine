//
//  CLArgumentInfo.m
//  CommandLineDemo
//
//  Created by 冷秋 on 2022/10/19.
//  Copyright © 2022 Magic-Unique. All rights reserved.
//

#import "CLCommandInfo.h"

@implementation CLBaseInfo

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _key = name;
        _name = name;
        _isRequired = YES;
    }
    return self;
}

- (BOOL)nonnull { _isRequired = YES; return _isRequired; }
- (BOOL)nullable { _isRequired = NO; return _isRequired; }

@end

@implementation CLOptionInfo
- (BOOL)isBOOL { return [@[@"BOOL", @"_BOOL"] containsObject:self.type.uppercaseString]; }

+ (instancetype)verboseOption {
    static CLOptionInfo *option = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        option = [[CLOptionInfo alloc] initWithName:@"verbose"];
        option.type = @"BOOL";
        option.note = @"Show more debugging information";
    });
    return option;
}

+ (instancetype)helpOption {
    static CLOptionInfo *option = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        option = [[CLOptionInfo alloc] initWithName:@"help"];
        option.type = @"BOOL";
        option.note = @"Show help banner of specified command";
    });
    return option;
}

+ (instancetype)silentOption {
    static CLOptionInfo *option = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        option = [[CLOptionInfo alloc] initWithName:@"silent"];
        option.type = @"BOOL";
        option.note = @"Show nothing";
    });
    return option;
}

+ (instancetype)plainOption {
    static CLOptionInfo *option = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        option = [[CLOptionInfo alloc] initWithName:@"no-ansi"];
        option.type = @"BOOL";
        option.note = @"Show output without ANSI codes";
    });
    return option;
}

+ (NSArray<CLOptionInfo *> *)defaultOptions {
    static NSArray<CLOptionInfo *> *options = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        options = @[[self silentOption], [self verboseOption], [self plainOption], [self helpOption]];
    });
    return options;
}

+ (CLOptionInfo *)defaultOptionForName:(NSString *)name {
    for (CLOptionInfo *item in [self defaultOptions]) {
        if ([item.name isEqualToString:name]) {
            return item;
        }
    }
    return nil;
}

@end

@implementation CLArgumentInfo @end



@implementation CLCommandInfo

- (CLOptionInfo *)optionInfoForName:(NSString *)name {
    return self.options[name] ?: [CLOptionInfo defaultOptionForName:name];
}

- (CLOptionInfo *)optionInfoForShortName:(char)shortName {
    NSArray<CLOptionInfo *> *options = self.options.allValues;
    for (CLOptionInfo *item in options) {
        if (item.shortName == shortName) {
            return item;
        }
    }
    return nil;
}

@end
