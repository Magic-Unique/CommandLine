//
//  CLLanguage+Country.m
//  CommandLine
//
//  Created by Magic-Unique on 2019/4/13.
//

#import "CLLanguage+Country.h"

@implementation CLLanguage (Country)

+ (instancetype)en_US {
    return [self languageWithMapBlock:^(NSMutableDictionary<CLLanguageKey, NSString *> * _Nonnull strings) {
        strings[CLVersionExplainLanguageKey] = @"Show the version of the tool";
        strings[CLHelpExplainLanguageKey] = @"Show help banner of specified command";
        strings[CLVerboseExplainLanguageKey] = @"Show more information";
        strings[CLSilentExplainLanguageKey] = @"Show nothing";
        strings[CLNoANSIExplainLanguageKey] = @"Show output without ANSI codes";
        
        strings[CLHelpUsageLanguageKey] = @"Usage";
        strings[CLHelpCommandsLanguageKey] = @"Commands";
        strings[CLHelpRequiresLanguageKey] = @"Requires";
        strings[CLHelpOptionsLanguageKey] = @"Options";
        
        strings[CLHelpCommandLanguageKey] = @"COMMAND";
        
        strings[CLParseErrorIllegalValueLanguageKey] = @"Error: argument key `%@` does not support value `%@`";
        strings[CLParseErrorUnknowQueryLanguageKey] = @"Error: illegal key `%@`";
    }];
}

+ (instancetype)zh_CN {
    return [self languageWithMapBlock:^(NSMutableDictionary<CLLanguageKey, NSString *> * _Nonnull strings) {
        strings[CLVersionExplainLanguageKey] = @"输出版本信息";
        strings[CLHelpExplainLanguageKey] = @"输出帮助信息";
        strings[CLVerboseExplainLanguageKey] = @"输出详细信息";
        strings[CLSilentExplainLanguageKey] = @"关闭所有输出";
        strings[CLNoANSIExplainLanguageKey] = @"关闭颜色输出";
        
        strings[CLHelpUsageLanguageKey] = @"使用方法";
        strings[CLHelpCommandsLanguageKey] = @"命令列表";
        strings[CLHelpRequiresLanguageKey] = @"必要参数";
        strings[CLHelpOptionsLanguageKey] = @"可选参数";
        
        strings[CLHelpCommandLanguageKey] = @"命令";
        
        strings[CLParseErrorIllegalValueLanguageKey] = @"错误：参数 `%@` 不能为 `%@`";
        strings[CLParseErrorUnknowQueryLanguageKey] = @"错误：无效关键字 `%@`";
    }];
}

@end
