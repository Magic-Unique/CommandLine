//
//  CLCommand+Request.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/20.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLCommand.h"

@class CLProcess;

@interface CLCommand (Parser)

+ (CLCommand *)commandWithArguments:(NSMutableArray *)arguments;

- (CLProcess *)processWithCommands:(NSArray *)commands arguments:(NSArray *)arguments;

@end
