//
//  Demo.h
//  CommandLineDemo
//
//  Created by 冷秋 on 2019/12/18.
//  Copyright © 2023 Magic-Unique. All rights reserved.
//

#import <CommandLine/CommandLine.h>
#import "CLCommand.h"
#import <MUFoundation/MUPath.h>

CLConvertClass(MUPath, CLPath) { return [MUPath pathWithString:string]; }

@interface Demo : CLCommand

@end
