//
//  CLCommand+Handler.h
//  CommandLine
//
//  Created by 冷秋 on 2018/6/4.
//

#import "CLCommand.h"

@interface CLCommand (Handler)

- (CLResponse *)_handleRequest:(CLRequest *)request;

@end
