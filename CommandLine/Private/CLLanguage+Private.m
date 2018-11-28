//
//  CLLanguage+Private.m
//  CommandLine
//
//  Created by 吴双 on 2018/11/13.
//

#import "CLLanguage+Private.h"

@implementation CLLanguage (Private)

- (NSString *)versionExplain {
    return self[CLVersionExplainLanguageKey];
}

- (NSString *)helpExplain {
    return self[CLHelpExplainLanguageKey];
}

- (NSString *)verboseExplain {
    return self[CLVerboseExplainLanguageKey];
}

- (NSString *)helpUsage {
    return self[CLHelpUsageLanguageKey];
}

- (NSString *)helpCommands {
    return self[CLHelpCommandsLanguageKey];
}

- (NSString *)helpRequires {
    return self[CLHelpRequiresLanguageKey];
}

- (NSString *)helpOptions {
    return self[CLHelpOptionsLanguageKey];
}

- (NSString *)helpCommand {
    return self[CLHelpCommandLanguageKey];
}

- (NSString *)errorIllegalValue {
    return self[CLParseErrorIllegalValueLanguageKey];
}

- (NSString *)errorUnknowQuery {
    return self[CLParseErrorUnknowQueryLanguageKey];
}

+ (NSString *)objectForKeyedSubscript:(NSString *)key {
    return [[CLLanguage current] objectForKeyedSubscript:key];
}

@end
