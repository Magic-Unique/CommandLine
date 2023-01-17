//
//  CommandLine.h
//  CommandLineDemo
//
//  Created by Magic-Unique on 2018/5/17.
//  Copyright © 2018年 unique. All rights reserved.
//

#ifndef Command_h
#define Command_h

#import "CLCommand.h"
#import "CLQuery.h"
#import "CLFlag.h"
#import "CLIOPath.h"
#import "CLProcess.h"

#import "CLCommand+Print.h"

#import "CLIO.h"
#import "CLLanguage.h"
#import "CLError.h"

#define CLCommandMain() return [CLCommand process];

#define CLMainExplain [CLCommand mainCommand].explain

#define CLMakeSubcommand(cls, pre) [CLCommand defineCommandsForClass:((cls *)0x0, @#cls) metaSelectorPrefix:@#pre];

#endif /* Command_h */
