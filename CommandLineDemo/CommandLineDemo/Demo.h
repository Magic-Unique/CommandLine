//
//  Demo.h
//  CommandLineDemo
//
//  Created by 吴双 on 2019/12/18.
//  Copyright © 2019 unique. All rights reserved.
//

#import <CommandLine/CommandLine.h>
#import "CLAbstractCommand.h"
#import <MUFoundation/MUPath.h>

CLConvertClass(MUPath, CLPath) { return [MUPath pathWithString:string]; }

@interface Demo : CLAbstractCommand

@end
