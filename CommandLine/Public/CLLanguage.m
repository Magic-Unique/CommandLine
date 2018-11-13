//
//  CLLanguage.m
//  CommandLine
//
//  Created by 吴双 on 2018/11/13.
//

#import "CLLanguage.h"

#define ConstLanguageKey(name) NSString *const name = @#name;

ConstLanguageKey(CLVersionExplainLanguageKey);
ConstLanguageKey(CLHelpExplainLanguageKey);
ConstLanguageKey(CLVerboseExplainLanguageKey);

ConstLanguageKey(CLHelpUsageLanguageKey);
ConstLanguageKey(CLHelpCommandsLanguageKey);
ConstLanguageKey(CLHelpRequiresLanguageKey);
ConstLanguageKey(CLHelpOptionsLanguageKey);

ConstLanguageKey(CLHelpCommandLanguageKey);

@interface CLLanguage ()

@property (nonatomic, strong, readonly) NSMutableDictionary *strings;

@end

static CLLanguage *_current_language_ = nil;

@implementation CLLanguage

+ (instancetype)current {
    if (_current_language_ == nil) {
        _current_language_ = [self EnglishLanguage];
    }
    return _current_language_;
}

+ (NSDictionary *)defaultStrings {
    return @{CLVersionExplainLanguageKey: @"Show the version of the tool",
             CLHelpExplainLanguageKey: @"Show help banner of specified command",
             CLVerboseExplainLanguageKey: @"Show more information",
             
             CLHelpUsageLanguageKey: @"Usage",
             CLHelpCommandsLanguageKey: @"Commands",
             CLHelpRequiresLanguageKey: @"Requires",
             CLHelpOptionsLanguageKey: @"Options",
             
             CLHelpCommandLanguageKey: @"COMMAND",
             };
}

+ (instancetype)ChineseLanguage {
    return [self languageWithMapBlock:^(NSMutableDictionary *strings) {
        strings[CLVersionExplainLanguageKey] = @"输出版本信息";
        strings[CLHelpExplainLanguageKey] = @"输出帮助信息";
        strings[CLVerboseExplainLanguageKey] = @"输出详细信息";
        
        strings[CLHelpUsageLanguageKey] = @"使用方法";
        strings[CLHelpCommandsLanguageKey] = @"命令列表";
        strings[CLHelpRequiresLanguageKey] = @"必要参数";
        strings[CLHelpOptionsLanguageKey] = @"可选参数";
        
        strings[CLHelpCommandLanguageKey] = @"命令";
    }];
}

+ (instancetype)EnglishLanguage {
    return [self languageWithStrings:[self defaultStrings]];
}

+ (instancetype)languageWithMapBlock:(void (^)(NSMutableDictionary<CLLanguageKey,NSString *> *))mapBlock {
    NSParameterAssert(mapBlock);
    NSMutableDictionary *map = [NSMutableDictionary dictionary];
    mapBlock(map);
    return [self languageWithStrings:map.copy];
}

+ (instancetype)languageWithStrings:(NSDictionary *)strings {
    return [[self alloc] initWithStrings:strings];
}

- (instancetype)initWithStrings:(NSDictionary *)strings {
    self = [super init];
    if (self) {
        _strings = [strings mutableCopy];
    }
    return self;
}

- (void)setObject:(NSString *)obj forKeyedSubscript:(CLLanguageKey)key {
    [self.strings setObject:obj forKeyedSubscript:key];
}

- (NSString *)objectForKeyedSubscript:(CLLanguageKey)key {
    NSString *object = [self.strings objectForKeyedSubscript:key];
    if (!object) {
        object = [[CLLanguage defaultStrings] objectForKeyedSubscript:key];
    }
    return object;
}

- (void)apply {
    _current_language_ = self;
}

@end
