//
//  CLCommand+Demo.m
//  CommandLineDemo
//
//  Created by 吴双 on 2019/2/4.
//  Copyright © 2019 unique. All rights reserved.
//

#import "CLCommand+Demo.h"
#import <CommandLine/MUHookMetaMacro.h>


#define MUHSTR(str)                     [NSString stringWithUTF8String:str]

#define _MUHEncode(INDEX, CONTEXT, VAR) MUHSTR(@encode(VAR)),

#define MUHEncode(...)                  [@[muhmacro_foreach_cxt(_MUHEncode,,,__VA_ARGS__)] componentsJoinedByString:@""]

#define _CLAddQuery(INDEX, CONTEXT, VAR) __unused CLQuery *VAR = CONTEXT.setQuery(@#VAR);
#define CLAddQueries(cmd, ...) cl_metamacro_foreach_cxt(_CLAddQuery,,cmd,__VA_ARGS__)

#define _CLReceiveTextEach(INDEX, CONTEXT, VAR) __unused NSString *VAR = [request stringForQuery:@#VAR];
#define CLReceiveQText(...) cl_metamacro_foreach_cxt(_CLReceiveTextEach,,,__VA_ARGS__)

#define _CLReceivePathPath(INDEX, CONTEXT, VAR) __unused NSString *VAR = [request pathForQuery:@#VAR];
#define CLReceivePath(...) cl_metamacro_foreach_cxt(_CLReceivePathPath,,,__VA_ARGS__)

#define _CLReceiveFlag(INDEX, CONTEXT, VAR) __unused BOOL VAR = [request flag:@#VAR];
#define CLReceiveFlag(...) cl_metamacro_foreach_cxt(_CLReceiveFlag,,,__VA_ARGS__)

#define _CLReceiveInteger(INDEX, CONTEXT, VAR) __unused NSInteger VAR = [request integerValueForQuery:@#VAR];
#define CLReceiveInteger(...) cl_metamacro_foreach_cxt(_CLReceiveInteger,,,__VA_ARGS__)

//pathForIndex
#define _CLReceiveInteger(INDEX, CONTEXT, VAR) __unused NSInteger VAR = [request integerValueForQuery:@#VAR];
#define CLReceiveInteger(...) cl_metamacro_foreach_cxt(_CLReceiveInteger,,,__VA_ARGS__)

@implementation CLCommand (Demo)

+ (void)__init_demo:(CLCommand *)main {
    CLSubcmd(cache);
    cache.explain = @"Manipulate the CocoaPods cache";
    CLAddQueries(cache, name);
    [cache onHandlerRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
        CLReceiveQText(name, mobileprovision, qurh);
        CLReceivePath(input, output);
        CLReceiveFlag(xml, json);
        CLReceiveInteger(count);
        return nil;
    }];
    CLSubcmd(deintegrate);
    deintegrate.explain = @"Deintegrate CocoaPods from your project";
    [deintegrate onHandlerRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
        return nil;
    }];
    CLCommand *env = [CLCommand.main defineSubcommand:@"env"];
    env.explain = @"Display pod environment";
    [env onHandlerRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
        return nil;
    }];
    
    CLCommand *print = [CLCommand.main defineSubcommand:@"print"];
    print.explain = @"打印文件详细信息";
    print.setQuery(@"array").setAbbr('a').asNumber().multify().require();
    [print onHandlerRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
        return nil;
    }];
}

@end
