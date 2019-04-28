//
//  CLCommand+Demo.m
//  CommandLineDemo
//
//  Created by Magic-Unique on 2019/2/4.
//  Copyright © 2019 unique. All rights reserved.
//

#import "CLCommand+Demo.h"
#import "MUHookMetaMacro.h"


#define MUHSTR(str)                     [NSString stringWithUTF8String:str]

#define _MUHEncode(INDEX, CONTEXT, VAR) MUHSTR(@encode(VAR)),

#define MUHEncode(...)                  [@[muhmacro_foreach_cxt(_MUHEncode,,,__VA_ARGS__)] componentsJoinedByString:@""]

#define _CLAddQuery(INDEX, CONTEXT, VAR) __unused CLQuery *VAR = CONTEXT.setQuery(@#VAR);
#define CLAddQueries(cmd, ...) cl_metamacro_foreach_cxt(_CLAddQuery,,cmd,__VA_ARGS__)

#define _CLReceiveTextEach(INDEX, CONTEXT, VAR) __unused NSString *VAR = [process stringForQuery:@#VAR];
#define CLReceiveQText(...) cl_metamacro_foreach_cxt(_CLReceiveTextEach,,,__VA_ARGS__)

#define _CLReceivePathPath(INDEX, CONTEXT, VAR) __unused NSString *VAR = [process pathForQuery:@#VAR];
#define CLReceivePath(...) cl_metamacro_foreach_cxt(_CLReceivePathPath,,,__VA_ARGS__)

#define _CLReceiveFlag(INDEX, CONTEXT, VAR) __unused BOOL VAR = [process flag:@#VAR];
#define CLReceiveFlag(...) cl_metamacro_foreach_cxt(_CLReceiveFlag,,,__VA_ARGS__)

#define _CLReceiveInteger(INDEX, CONTEXT, VAR) __unused NSInteger VAR = [process integerValueForQuery:@#VAR];
#define CLReceiveInteger(...) cl_metamacro_foreach_cxt(_CLReceiveInteger,,,__VA_ARGS__)

//pathForIndex
#define _CLReceiveInteger(INDEX, CONTEXT, VAR) __unused NSInteger VAR = [process integerValueForQuery:@#VAR];
#define CLReceiveInteger(...) cl_metamacro_foreach_cxt(_CLReceiveInteger,,,__VA_ARGS__)

@implementation CLCommand (Demo)

+ (void)__init_demo {
    CLCommand *cache = [[CLCommand mainCommand] defineSubcommand:@"cache"];
    cache.explain = @"Manipulate the CocoaPods cache";
    cache.version = @"1.0.0";
    cache.setQuery(@"query-require").require();
    cache.setQuery(@"query-optional").optional();
    cache.setFlag(@"flag");
    cache.addRequirePath(@"path-require");
    cache.addOptionalPath(@"path-optional");
    [cache onHandlerRequest:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
        CLReceiveQText(name, mobileprovision, qurh);
        CLReceivePath(input, output);
        CLReceiveFlag(xml, json);
        CLReceiveInteger(count);
        return EXIT_SUCCESS;
    }];
    CLCommand *deintegrate = [[CLCommand mainCommand] defineSubcommand:@"deintegrate"];
    deintegrate.explain = @"Deintegrate CocoaPods from your project";
    [deintegrate onHandlerRequest:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
        return EXIT_SUCCESS;
    }];
    CLCommand *env = [CLCommand.mainCommand defineSubcommand:@"env"];
    env.explain = @"Display pod environment";
    [env onHandlerRequest:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
        return EXIT_SUCCESS;
    }];
    
    CLCommand *print = [CLCommand.mainCommand defineSubcommand:@"print"];
    print.explain = @"打印文件详细信息";
    print.setQuery(@"array").setAbbr('a').asNumber().multify().require();
    [print onHandlerRequest:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
        return EXIT_SUCCESS;
    }];
    
    CLCommand *repo = [CLCommand.mainCommand defineSubcommand:@"repo"];
    CLCommand *list = [repo defineForwardingSubcommand:@"list"];
    list.setQuery(@"query").setAbbr('q').optional().setExplain(@"query");
    list.setFlag(@"flag").setAbbr('f').setExplain(@"Flag");
    [list onHandlerRequest:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
        NSLog(@"on handler list command [--query=%@]", process.queries[@"query"]);
        return EXIT_SUCCESS;
    }];
}

@end
