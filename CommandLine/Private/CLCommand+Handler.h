//
//  CLCommand+Handler.h
//  CommandLine
//
//  Created by 吴双 on 2018/6/4.
//

#import "CLCommand.h"

@interface CLCommand (Handler)

- (CLResponse *)_handleRequest:(CLRequest *)request;

@end
