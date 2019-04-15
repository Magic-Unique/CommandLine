//
//  CLCommand+Request.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/20.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLCommand.h"

@interface CLCommand (Request)

+ (CLCommand *)commandWithArguments:(NSMutableArray *)arguments;

- (CLRequest *)requestWithCommands:(NSArray *)commands arguments:(NSArray *)arguments;

@end
