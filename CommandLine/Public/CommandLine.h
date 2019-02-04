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
#import "CLCommand+Print.h"
#import "CLRequest.h"
#import "CLResponse.h"

#import "CLLanguage.h"

#import "CCText.h"

#import "CLTerminal.h"

#define CLCommandMain() return (int)[CLCommand handleRequest:[CLRequest request]].error.code;

#endif /* CommandLine_h */
