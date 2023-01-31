//
//  CommandLine.h
//  Pods
//
//  Created by 冷秋 on 2019/8/24.
//

#ifndef CommandLine_h
#define CommandLine_h

#if __has_include(<CommandLine/CLCommand.h>)
#import <CommandLine/CLCommand.h>
#import <CommandLine/CLRunner.h>
#import <CommandLine/CLType.h>
#import <CommandLine/CLIO.h>
#elif __has_include("CLCommand.h")
#import "CLCommand.h"
#endif

#if __has_include(<CommandLine/Tools.h>)
#import <CommandLine/Tools.h>
#elif __has_include("Tools.h")
#import "Tools.h"
#endif

#if __has_include(<CommandLine/Launcher.h>)
#import <CommandLine/Launcher.h>
#elif __has_include("Launcher.h")
#import "Launcher.h"
#endif

#if __has_include(<CommandLine/ANSI.h>)
#import <CommandLine/ANSI.h>
#elif __has_include("ANSI.h")
#import "ANSI.h"
#endif

#if __has_include(<CommandLine/Interface.h>)
#import <CommandLine/Interface.h>
#elif __has_include("Interface.h")
#import "Interface.h"
#endif

#endif /* CommandLine_h */
