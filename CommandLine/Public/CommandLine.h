//
//  CommandLine.h
//  CommandLineDemo
//
//  Created by Magic-Unique on 2018/5/17.
//  Copyright © 2018年 unique. All rights reserved.
//

#ifndef CommandLine_h
#define CommandLine_h

#import "CLCommand.h"
#import "CLQuery.h"
#import "CLFlag.h"
#import "CLIOPath.h"
#import "CLRequest.h"
#import "CLResponse.h"

#import "CLCommand+Print.h"

#import "CLLanguage.h"
#import "CCText.h"
#import "CLTerminal.h"

#define CLCommandMain() return (int)[CLCommand handleRequest:[CLRequest request]].error.code;

#define CLMainExplain [CLCommand mainCommand].explain

#define CLMakeSubcommand(cls, pre) [CLCommand defineCommandsForClass:((cls *)0x0, @#cls) metaSelectorPrefix:@#pre];

#endif /* CommandLine_h */
