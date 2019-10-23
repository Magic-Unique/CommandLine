//
//  CLCommand+Print.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/22.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLCommand+Print.h"
#import "CLQuery.h"
#import "CLFlag.h"
#import "CLIOPath.h"
#import "CLLanguage+Private.h"
#import "NSString+CommandLine.h"
#import <CommandLine/ANSI.h>
#import "CLError.h"
#import "NSError+CommandLine.h"
#import "CLExplain+Private.h"

@implementation CLCommand (Print)

- (void)printHelpInfo {
    
    __block NSUInteger maxKey = 0;
    void (^CLCompareMaxLength)(NSString *string) = ^(NSString *string) {
        if (strlen(string.UTF8String) > maxKey) {
            maxKey = strlen(string.UTF8String);
        }
    };
    
    BOOL commandContainsAbbr = NO;
    BOOL requireContainsAbbr = NO;
    BOOL optionalContainsAbbr = NO;
    
    CLSortType parametersSortType = [CLCommand parametersSortType];
    
    NSMutableArray<CLCommand *> *subcommands        = [self.subcommands.allValues mutableCopy];
    NSMutableArray<CLQuery *>   *optionalQueries    = [NSMutableArray array];
    NSMutableArray<CLQuery *>   *requireQueries     = [NSMutableArray array];
    for (CLQuery *query in self.queries.allValues) {
        if (query.isOptional) {
            if (query.abbr != 0) {
                optionalContainsAbbr = YES;
            }
            [optionalQueries addObject:query];
        } else {
            if (query.abbr != 0) {
                requireContainsAbbr = YES;
            }
            [requireQueries addObject:query];
        }
    }
    NSMutableArray<CLFlag *>    *flags              = [NSMutableArray array];
    for (CLFlag *flag in self.customFlags.allValues) {
        if (flag.abbr != 0) {
            optionalContainsAbbr = YES;
        }
        [flags addObject:flag];
    }
    NSMutableArray<CLIOPath *>  *optionalIOPaths    = [NSMutableArray array];
    NSMutableArray<CLIOPath *>  *requireIOPaths     = [NSMutableArray array];
    for (CLIOPath *path in self.IOPaths) {
        if (path.isRequire) {
            [requireIOPaths addObject:path];
        } else {
            [optionalIOPaths addObject:path];
        }
    }
    
    if (parametersSortType == CLSortTypeByName) {
        [subcommands        sortUsingSelector:@selector(sortByKey:)];
        [optionalQueries    sortUsingSelector:@selector(sortByKey:)];
        [requireQueries     sortUsingSelector:@selector(sortByKey:)];
        [flags              sortUsingSelector:@selector(sortByKey:)];
        [requireIOPaths     sortUsingSelector:@selector(sortByKey:)];
        [optionalIOPaths    sortUsingSelector:@selector(sortByKey:)];
    }
    else if (parametersSortType == CLSortTypeByAddingQueue) {
        [subcommands        sortUsingSelector:@selector(sortByKey:)];
        [optionalQueries    sortUsingSelector:@selector(sortByIndex:)];
        [requireQueries     sortUsingSelector:@selector(sortByIndex:)];
        [flags              sortUsingSelector:@selector(sortByIndex:)];
        [requireIOPaths     sortUsingSelector:@selector(sortByIndex:)];
        [optionalIOPaths    sortUsingSelector:@selector(sortByIndex:)];
    }
    
    //  Calcular max key length
    [subcommands enumerateObjectsUsingBlock:^(CLCommand * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CLCompareMaxLength([obj titleWithAbbr:commandContainsAbbr]);
    }];
    [requireQueries enumerateObjectsUsingBlock:^(CLQuery * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CLCompareMaxLength([obj titleWithAbbr:requireContainsAbbr]);
    }];
    [requireIOPaths enumerateObjectsUsingBlock:^(CLIOPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CLCompareMaxLength([obj titleWithAbbr:requireContainsAbbr]);
    }];
    [optionalQueries enumerateObjectsUsingBlock:^(CLQuery * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CLCompareMaxLength([obj titleWithAbbr:optionalContainsAbbr]);
    }];
    [flags enumerateObjectsUsingBlock:^(CLFlag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CLCompareMaxLength([obj titleWithAbbr:optionalContainsAbbr]);
    }];
    [optionalIOPaths enumerateObjectsUsingBlock:^(CLIOPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CLCompareMaxLength([obj titleWithAbbr:optionalContainsAbbr]);
    }];
    [self.predefineFlags enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CLFlag * _Nonnull obj, BOOL * _Nonnull stop) {
        CLCompareMaxLength([obj titleWithAbbr:optionalContainsAbbr]);
    }];
    
    // Usage
    CCPrintf(CCStyleUnderline, @"%@:\n", CLCurrentLanguage.helpUsage);
    CCPrintf(0, @"\n");
    {
        NSString *commands = [[self commandPath] componentsJoinedByString:@" "];
        CCPrintf(0, @"    $ ");
        CCStyle style = CCStyleForegroundColorGreen;
        if (self.subcommands.count && self.task) {
            CCPrintf(style, @"%@ [%@]", commands, CLCurrentLanguage.helpCommand);
        } else if (self.task) {
            CCPrintf(style, @"%@", commands);
            if (self.IOPaths) {
                if (requireIOPaths.count) {
                    NSArray *requireList = [requireIOPaths valueForKeyPath:@"title"];
                    CCPrintf(CCStyleForegroundColorPurple, @" %@", [requireList componentsJoinedByString:@" "]);
                }
                if (optionalIOPaths.count) {
                    NSArray *optionalList = [optionalIOPaths valueForKeyPath:@"title"];
                    CCPrintf(CCStyleForegroundColorYellow, @" %@", [optionalList componentsJoinedByString:@" "]);
                }
            }
        } else if (self.subcommands.count) {
            CCPrintf(style, @"%@ <%@>", commands, CLCurrentLanguage.helpCommand);
        } else {
            NSAssert(NO, @"The command `%@` should contains a task or a subcommand", self.name);
        }
        CCPrintf(0, @"\n\n");
        
        if (self.explain.length) {
            CCPrintf(0, @"    %@\n", self.explain);
            CCPrintf(0, @"\n");
        }
    }
    
    // Commands
    if (self.subcommands.count) {
        CCPrintf(CCStyleUnderline, @"%@:\n", CLCurrentLanguage.helpCommands);
        CCPrintf(0, @"\n");
        [subcommands enumerateObjectsUsingBlock:^(CLCommand * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CLCommand *command = obj;
            NSString *title = [command titleWithAbbr:commandContainsAbbr];
            
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorGreen, title);
            CCPrintf(0, CLSpaceString(maxKey + 3 - strlen(title.UTF8String)));
            if (command.explain) {
                CCPrintf(0, command.explain);
            }
            CCPrintf(0, @"\n");
        }];
        CCPrintf(0, @"\n");
    }
    
    // Require
    const NSUInteger REQUIRE_COUNT = requireQueries.count + requireIOPaths.count;
    if (REQUIRE_COUNT) {
        
        CCPrintf(CCStyleUnderline, @"%@:\n", CLCurrentLanguage.helpRequires);
        CCPrintf(0, @"\n");
        
        [requireQueries enumerateObjectsUsingBlock:^(CLQuery * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = [obj titleWithAbbr:requireContainsAbbr];
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorGreen, title);
            CCPrintf(0, CLSpaceString(maxKey + 3 - strlen(title.UTF8String)));
            CCPrintf(0, obj.subtitle);
            CCPrintf(0, @"\n");
        }];
        
        if (requireQueries.count && requireIOPaths.count) {
            CCPrintf(0, @"\n");
        }
        
        [requireIOPaths enumerateObjectsUsingBlock:^(CLIOPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = [obj titleWithAbbr:requireContainsAbbr];
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorGreen, title);
            CCPrintf(0, CLSpaceString(maxKey + 3 - strlen(title.UTF8String)));
            CCPrintf(0, obj.subtitle);
            CCPrintf(0, @"\n");
        }];
        
        CCPrintf(0, @"\n");
    }
    
    //  Optional
    const NSUInteger OPTIONAL_COUNT = self.flags.count + optionalQueries.count + optionalIOPaths.count;
    if (OPTIONAL_COUNT) {
        NSUInteger printedCount = 0;
        
        CCPrintf(CCStyleUnderline, @"%@:\n", CLCurrentLanguage.helpOptions);
        CCPrintf(0, @"\n");
        
        [optionalQueries enumerateObjectsUsingBlock:^(CLQuery * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = [obj titleWithAbbr:optionalContainsAbbr];
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorBlue, title);
            CCPrintf(0, CLSpaceString(maxKey + 3 - strlen(title.UTF8String)));
            CCPrintf(0, obj.subtitle);
            CCPrintf(0, @"\n");
        }];
        printedCount += optionalQueries.count;
        
        if (printedCount && (OPTIONAL_COUNT - printedCount)) {
            CCPrintf(0, @"\n");
        }
        
        [flags enumerateObjectsUsingBlock:^(CLFlag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = [obj titleWithAbbr:optionalContainsAbbr];
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorBlue, title);
            CCPrintf(0, CLSpaceString(maxKey + 3 - strlen(title.UTF8String)));
            CCPrintf(0, obj.subtitle);
            CCPrintf(0, @"\n");
        }];
        printedCount += flags.count;
        
        if (printedCount && (OPTIONAL_COUNT - printedCount)) {
            CCPrintf(0, @"\n");
        }
        
        [optionalIOPaths enumerateObjectsUsingBlock:^(CLIOPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = [obj titleWithAbbr:optionalContainsAbbr];
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorBlue, title);
            CCPrintf(0, CLSpaceString(maxKey + 3 - strlen(title.UTF8String)));
            CCPrintf(0, obj.subtitle);
            CCPrintf(0, @"\n");
        }];
        printedCount += optionalIOPaths.count;
        
        if (printedCount && (OPTIONAL_COUNT - printedCount)) {
            CCPrintf(0, @"\n");
        }
        
        [self.predefineFlags.allValues enumerateObjectsUsingBlock:^(CLFlag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = [obj titleWithAbbr:optionalContainsAbbr];
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorBlue, title);
            CCPrintf(0, CLSpaceString(maxKey + 3 - strlen(title.UTF8String)));
            CCPrintf(0, obj.subtitle);
            CCPrintf(0, @"\n");
        }];
        
        CCPrintf(0, @"\n");
    }
}

@end
