//
//  CLCommand+Print.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/22.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLCommand.h"

@interface CLCommand (Print)

@property (nonatomic, strong, readonly) NSArray *commandNodes;

- (void)printHelpInfo;

+ (void)printVersion;

@end
