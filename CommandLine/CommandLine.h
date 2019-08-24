//
//  CommandLine.h
//  Pods
//
//  Created by 吴双 on 2019/8/24.
//

#ifndef CommandLine_h
#define CommandLine_h

#if __has_include(<CommandLine/Command.h>)
#import <CommandLine/Command.h>
#elif __has_include("Command.h")
#import "Command.h"
#else
#define CLCommand NSObject
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

#endif /* CommandLine_h */
