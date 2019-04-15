//
//  CLCommand+Handler.h
//  CommandLine
//
//  Created by Magic-Unique on 2019/4/12.
//

#import "CLCommand.h"

@class CLResponse, CLRequest;

@interface CLCommand (Handler)

+ (CLResponse * _Nonnull)handleProcess;

+ (CLResponse * _Nonnull)handleArguments:(NSArray * _Nonnull)arguments;

+ (CLResponse * _Nonnull)handleArgc:(int)argc argv:(const char * _Nonnull [_Nonnull])argv;

@end
