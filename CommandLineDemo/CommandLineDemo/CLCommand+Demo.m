//
//  CLCommand+Demo.m
//  CommandLineDemo
//
//  Created by Magic-Unique on 2019/2/4.
//  Copyright © 2019 unique. All rights reserved.
//

#import "CLCommand+Demo.h"
#import "MUHookMetaMacro.h"

#define _CLMethodNameItem(INDEX,CONTEXT,VAR) VAR:(CLCommand *)VAR
#define CLDefineCommand(args...) cl_metamacro_concat(+ (void)__cl_def_, cl_metamacro_foreach_cxt(_CLMethodNameItem,,,main,##args))

//#define CLDefineCommand(args...) _CLDefineCommand(##args)

@implementation CLCommand (Demo)

CLDefineCommand(pod, repo, update) {
    [update handleProcess:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
        return 0;
    }];
}

CLDefineCommand() {
//    NSLog(@"%@", main);
}

//+ (void)__init_demo {
//    CLCommand *cache = [[CLCommand mainCommand] defineSubcommand:@"cache"];
//    cache.explain = @"Manipulate the CocoaPods cache";
//    cache.version = @"1.0.0";
//    cache.setQuery(@"query-require").require();
//    cache.setQuery(@"query-optional").optional();
//    cache.setFlag(@"flag");
//    cache.addRequirePath(@"path-require");
//    cache.addOptionalPath(@"path-optional");
//    [cache handleProcess:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
//        CLReceiveQText(name, mobileprovision, qurh);
//        CLReceivePath(input, output);
//        CLReceiveFlag(xml, json);
//        CLReceiveInteger(count);
//        return EXIT_SUCCESS;
//    }];
//    CLCommand *deintegrate = [[CLCommand mainCommand] defineSubcommand:@"deintegrate"];
//    deintegrate.explain = @"Deintegrate CocoaPods from your project";
//    [deintegrate handleProcess:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
//        return EXIT_SUCCESS;
//    }];
//    CLCommand *env = [CLCommand.mainCommand defineSubcommand:@"env"];
//    env.explain = @"Display pod environment";
//    [env handleProcess:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
//        return EXIT_SUCCESS;
//    }];
//
//    CLCommand *print = [CLCommand.mainCommand defineSubcommand:@"test-mult"];
//    print.explain = @"Test mult-query";
//    print.setQuery(@"key1").require().setMultiType(CLQueryMultiTypeSeparatedByComma).setExample(@"v").setExplain(@"Value");
//    print.setQuery(@"key2").require().setMultiType(CLQueryMultiTypeMoreKeyValue).setExample(@"v").setExplain(@"Value");
//    [print handleProcess:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
//        id key1 = process.queries[@"key1"];
//        id key2 = process.queries[@"key2"];
//        CLSuccess(@"%@", key1);
//        CLSuccess(@"%@", key2);
//        return EXIT_SUCCESS;
//    }];
//
//    CLCommand *repo = [CLCommand.mainCommand defineSubcommand:@"repo"];
//    CLCommand *list = [repo defineForwardingSubcommand:@"list"];
//    list.setQuery(@"query").setAbbr('q').optional().setExplain(@"query");
//    list.setFlag(@"flag").setAbbr('f').setExplain(@"Flag");
//    [list handleProcess:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
//        CLError(@"on handler list command [--query=%@]", process.queries[@"query"]);
//        return EXIT_SUCCESS;
//    }];
//}

@end
