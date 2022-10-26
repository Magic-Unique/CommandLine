//
//  CLArgumentInfo.m
//  CommandLineDemo
//
//  Created by 吴双 on 2022/10/19.
//  Copyright © 2022 unique. All rights reserved.
//

#import "CLCommandInfo.h"

@implementation CLBaseInfo

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

- (BOOL)nonnull { _isRequired = YES; return _isRequired; }
- (BOOL)nullable { _isRequired = NO; return _isRequired; }

@end

@implementation CLOptionInfo
- (BOOL)isBOOL { return [self.type isEqualToString:@"CLBool"]; }

+ (instancetype)verboseOption {
    static CLOptionInfo *option = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        option = [[CLOptionInfo alloc] initWithName:@"verbose"];
        option.type = @"CLBool";
        option.note = @"Show more debugging information";
    });
    return option;
}

+ (instancetype)helpOption {
    static CLOptionInfo *option = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        option = [[CLOptionInfo alloc] initWithName:@"help"];
        option.type = @"CLBool";
        option.note = @"Show help banner of specified command";
    });
    return option;
}

+ (instancetype)silentOption {
    static CLOptionInfo *option = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        option = [[CLOptionInfo alloc] initWithName:@"silent"];
        option.type = @"CLBool";
        option.note = @"Show nothing";
    });
    return option;
}

+ (instancetype)plainOption {
    static CLOptionInfo *option = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        option = [[CLOptionInfo alloc] initWithName:@"no-ansi"];
        option.type = @"CLBool";
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

@end

@implementation CLArgumentInfo @end



@implementation CLCommandInfo

- (CLOptionInfo *)optionInfoForName:(NSString *)name {
    return self.options[name];
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
