//
//  CLLanguage.m
//  CommandLine
//
//  Created by Magic-Unique on 2018/11/13.
//

#import "CLLanguage.h"
#import "CLLanguage+Country.h"

#define ConstLanguageKey(name) NSString *const name = @#name;

ConstLanguageKey(CLVersionExplainLanguageKey);
ConstLanguageKey(CLHelpExplainLanguageKey);
ConstLanguageKey(CLVerboseExplainLanguageKey);
ConstLanguageKey(CLSilentExplainLanguageKey);
ConstLanguageKey(CLNoANSIExplainLanguageKey);

ConstLanguageKey(CLHelpUsageLanguageKey);
ConstLanguageKey(CLHelpCommandsLanguageKey);
ConstLanguageKey(CLHelpRequiresLanguageKey);
ConstLanguageKey(CLHelpOptionsLanguageKey);

ConstLanguageKey(CLHelpCommandLanguageKey);

ConstLanguageKey(CLParseErrorIllegalValueLanguageKey);
ConstLanguageKey(CLParseErrorUnknowQueryLanguageKey);

@interface CLLanguage ()

@property (nonatomic, strong, readonly) NSMutableDictionary *strings;

@end

static CLLanguage *_current_language_ = nil;

@implementation CLLanguage

+ (instancetype)currentLanguage {
    if (_current_language_ == nil) {
        NSString *LANG = [NSProcessInfo processInfo].environment[@"LANG"];
        LANG = [LANG componentsSeparatedByString:@"."].firstObject;
        CLLanguage *language = [CLLanguage __languageWithKey:LANG];
        if (!language) {
            language = [CLLanguage en_US];
        }
        _current_language_ = language;
    }
    return _current_language_;
}

+ (NSDictionary *)defaultStrings {
    return @{CLVersionExplainLanguageKey: @"Show the version of the tool",
             CLHelpExplainLanguageKey: @"Show help banner of specified command",
             CLVerboseExplainLanguageKey: @"Show more information",
             CLSilentExplainLanguageKey: @"Show nothing",
             CLNoANSIExplainLanguageKey: @"Show output without ANSI codes",
             
             CLHelpUsageLanguageKey: @"Usage",
             CLHelpCommandsLanguageKey: @"Commands",
             CLHelpRequiresLanguageKey: @"Requires",
             CLHelpOptionsLanguageKey: @"Options",
             
             CLHelpCommandLanguageKey: @"COMMAND",
             
             CLParseErrorIllegalValueLanguageKey: @"Error: argument key `%@` does not support value `%@`",
             CLParseErrorUnknowQueryLanguageKey: @"Error: illegal key `%@`",
             };
}

+ (CLLanguage *)__languageWithKey:(NSString *)key {
    if ([CLLanguage respondsToSelector:NSSelectorFromString(key)]) {
        CLLanguage *language = [CLLanguage performSelector:NSSelectorFromString(key)];
        if ([language isKindOfClass:[CLLanguage class]]) {
            return language;
        }
    }
    return nil;
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
