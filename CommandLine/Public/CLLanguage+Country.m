//
//  CLLanguage+Country.m
//  CommandLine
//
//  Created by Magic-Unique on 2019/4/13.
//

#import "CLLanguage+Country.h"
#import "CCText.h"

@implementation CLLanguage (Country)

+ (instancetype)EnglishLanguage {
    return [self languageWithMapBlock:^(NSMutableDictionary<CLLanguageKey, NSString *> * _Nonnull strings) {
        strings[CLVersionExplainLanguageKey] = @"Show the version of the tool";
        strings[CLHelpExplainLanguageKey] = @"Show help banner of specified command";
        strings[CLVerboseExplainLanguageKey] = @"Show more information";
        
        strings[CLHelpUsageLanguageKey] = @"Usage";
        strings[CLHelpCommandsLanguageKey] = @"Commands";
        strings[CLHelpRequiresLanguageKey] = @"Requires";
        strings[CLHelpOptionsLanguageKey] = @"Options";
        
        strings[CLHelpCommandLanguageKey] = @"COMMAND";
        
        strings[CLParseErrorIllegalValueLanguageKey] = @"Error: argument key `%@` does not support value `%@`";
        strings[CLParseErrorUnknowQueryLanguageKey] = @"Error: illegal key `%@`";
        
        strings[CLHelpCommandDefaultExplainKey] = [NSString stringWithFormat:@"Call %@ to change this line", CCText(CCStyleLight, @"%%@.explain = @\"Value you want.\"")];
    }];
}

+ (instancetype)ChineseLanguage {
    return [self languageWithMapBlock:^(NSMutableDictionary<CLLanguageKey, NSString *> * _Nonnull strings) {
        strings[CLVersionExplainLanguageKey] = @"输出版本信息";
        strings[CLHelpExplainLanguageKey] = @"输出帮助信息";
        strings[CLVerboseExplainLanguageKey] = @"输出详细信息";
        
        strings[CLHelpUsageLanguageKey] = @"使用方法";
        strings[CLHelpCommandsLanguageKey] = @"命令列表";
        strings[CLHelpRequiresLanguageKey] = @"必要参数";
        strings[CLHelpOptionsLanguageKey] = @"可选参数";
        
        strings[CLHelpCommandLanguageKey] = @"命令";
        
        strings[CLParseErrorIllegalValueLanguageKey] = @"错误：参数 `%@` 不能为 `%@`";
        strings[CLParseErrorUnknowQueryLanguageKey] = @"错误：无效关键字 `%@`";
        
        strings[CLHelpCommandDefaultExplainKey] = [NSString stringWithFormat:@"请执行 %@ 来改变此行的内容", CCText(CCStyleLight, @"%%@.explain = @\"命令详细描述\"")];
    }];
}

@end