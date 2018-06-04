//
//  CLConst.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/22.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLConst.h"

#ifdef COMMMANDLINE_USE_CHINESE

NSString *const CLVersionExplain    = @"输出版本信息";
NSString *const CLHelpExplain       = @"输出帮助信息";
NSString *const CLVerboseExplain    = @"输出调试信息";

NSString *const CLHelpUsage         = @"使用方法";
NSString *const CLHelpCommands      = @"命令列表";
NSString *const CLHelpRequires      = @"必要参数";
NSString *const CLHelpOptions       = @"可选参数";

NSString *const CLHelpCommand       = @"命令";

#else

NSString *const CLVersionExplain    = @"Show the version of the tool";
NSString *const CLHelpExplain       = @"Show help banner of specified command";
NSString *const CLVerboseExplain    = @"Show more debugging information";

NSString *const CLHelpUsage         = @"Usage";
NSString *const CLHelpCommands      = @"Commands";
NSString *const CLHelpRequires      = @"Requires";
NSString *const CLHelpOptions       = @"Options";

NSString *const CLHelpCommand       = @"COMMAND";

#endif
