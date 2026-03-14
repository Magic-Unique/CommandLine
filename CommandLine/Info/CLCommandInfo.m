//
//  CLArgumentInfo.m
//  CommandLineDemo
//
//  Created by 冷秋 on 2022/10/19.
//  Copyright © 2022 Magic-Unique. All rights reserved.
//

#import "CLCommandInfo.h"

@implementation CLBaseInfo

- (instancetype)initWithName:(NSString *)name defineIndex:(NSInteger)defineIndex {
    self = [super init];
    if (self) {
        _key = name;
        _name = name;
        _isRequired = YES;
        _defineIndex = defineIndex;
    }
    return self;
}

- (BOOL)nonnull { _isRequired = YES; return _isRequired; }
- (BOOL)nullable { _isRequired = NO; return _isRequired; }
- (BOOL)require { _isRequired = YES; return _isRequired; }
- (BOOL)optional { _isRequired = NO; return _isRequired; }

@end

@implementation CLEnviromentInfo
- (BOOL)isRequired { return !self.isBOOL && [super isRequired];}
- (BOOL)isBOOL { return [@[@"BOOL", @"_BOOL"] containsObject:self.type.uppercaseString]; }
@end

@implementation CLOptionInfo
- (BOOL)isRequired { return !self.isBOOL && [super isRequired];}
- (BOOL)isBOOL { return [@[@"BOOL", @"_BOOL"] containsObject:self.type.uppercaseString]; }

- (BOOL)showInUsage { _isShowInUsage = YES; return _isShowInUsage; }

+ (instancetype)verboseOption {
    static CLOptionInfo *option = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        option = [[CLOptionInfo alloc] initWithName:@"verbose" defineIndex:1000];
        option.type = @"BOOL";
        option.note = @"Show more debugging information";
    });
    return option;
}

+ (instancetype)helpOption {
    static CLOptionInfo *option = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        option = [[CLOptionInfo alloc] initWithName:@"help" defineIndex:1001];
        option.type = @"BOOL";
        option.note = @"Show help banner of specified command";
    });
    return option;
}

+ (instancetype)silentOption {
    static CLOptionInfo *option = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        option = [[CLOptionInfo alloc] initWithName:@"silent" defineIndex:1002];
        option.type = @"BOOL";
        option.note = @"Show nothing";
    });
    return option;
}

+ (instancetype)plainOption {
    static CLOptionInfo *option = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        option = [[CLOptionInfo alloc] initWithName:@"no-ansi" defineIndex:1003];
        option.type = @"BOOL";
        option.note = @"Show output without ANSI codes";
    });
    return option;
}

+ (instancetype)versionOption {
    static CLOptionInfo *option = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        option = [[CLOptionInfo alloc] initWithName:@"version" defineIndex:1003];
        option.type = @"BOOL";
        option.note = @"Show the version of the tool";
    });
    return option;
}

+ (NSArray<CLOptionInfo *> *)defaultOptions {
    static NSArray<CLOptionInfo *> *options = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        options = @[[self silentOption], [self verboseOption], [self plainOption], [self helpOption], [self versionOption]];
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

- (NSArray<CLOptionInfo *> *)optionsWithFilter:(BOOL (^)(CLOptionInfo *item))block {
    NSMutableArray<CLOptionInfo *> *result = [NSMutableArray array];
    NSArray<CLOptionInfo *> *options = self.options.allValues;
    for (CLOptionInfo *item in options) {
        if (block(item)) {
            [result addObject:item];
        }
    }
    [result sortUsingComparator:^NSComparisonResult(CLOptionInfo *obj1, CLOptionInfo *obj2) {
        return obj1.defineIndex > obj2.defineIndex;
    }];
    return result;
}

- (NSArray<CLArgumentInfo *> *)argumentsWithFilter:(BOOL (^)(CLArgumentInfo *item))block {
    NSMutableArray<CLArgumentInfo *> *result = [NSMutableArray array];
    NSArray<CLArgumentInfo *> *arguments = self.arguments.allValues;
    for (CLArgumentInfo *item in arguments) {
        if (block(item)) {
            [result addObject:item];
        }
    }
    [result sortUsingSelector:@selector(defineIndex)];
    return result;
    
}

@end
