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
#import "NSArray+CommandLine.h"
#import "CCText.h"
#import "CLError.h"
#import "NSError+CommandLine.h"

@implementation CLCommand (Print)

- (void)printHelpInfo {
    CCPrintf(CCStyleUnderline, @"%@:\n", CLCurrentLanguage.helpUsage);
    CCPrintf(0, @"\n");
    {
        NSString *commands = [[self commandPath] componentsJoinedByString:@" "];
        CCPrintf(0, @"    $ ");
        if (self.subcommands.count && self.task) {
            CCPrintf(CCStyleForegroundColorGreen, @"%@ [%@]", commands, CLCurrentLanguage.helpCommand);
        } else if (self.subcommands.count == 0 && self.task) {
            CCPrintf(CCStyleForegroundColorGreen, @"%@", commands);
        } else if (self.subcommands.count && self.task == nil) {
            CCPrintf(CCStyleForegroundColorGreen, @"%@ <%@>", commands, CLCurrentLanguage.helpCommand);
        } else {
            NSAssert(NO, @"The command `%@` should contains a task or a subcommand", self.name);
        }
        CCPrintf(0, @"\n\n");
        
        if (self.explain.length) {
            CCPrintf(0, @"    %@\n", self.explain);
            CCPrintf(0, @"\n");
        }
    }
    
    __block NSUInteger maxKey = 0;
    void (^CLCompareMaxLength)(NSString *string) = ^(NSString *string) {
        if (strlen(string.UTF8String) > maxKey) {
            maxKey = strlen(string.UTF8String);
        }
    };
    NSMutableArray *optionalQueryKeys = [NSMutableArray array];
    NSMutableArray *requireQueryKeys = [NSMutableArray array];
    NSMutableArray *optionalIOPaths = [NSMutableArray array];
    NSMutableArray *requireIOPaths = [NSMutableArray array];
    if (self.subcommands.count + self.queries.count + self.flags.count) {
        [self.subcommands enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CLCommand * _Nonnull obj, BOOL * _Nonnull stop) {
            CLCompareMaxLength(obj.title);
        }];
        [self.queries enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CLQuery * _Nonnull obj, BOOL * _Nonnull stop) {
            CLCompareMaxLength(obj.title);
            if (obj.isOptional) {
                [optionalQueryKeys addObject:obj.key];
            } else {
                [requireQueryKeys addObject:obj.key];
            }
        }];
        [self.flags enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CLFlag * _Nonnull obj, BOOL * _Nonnull stop) {
            CLCompareMaxLength(obj.title);
        }];
        [self.IOPaths enumerateObjectsUsingBlock:^(CLIOPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CLCompareMaxLength(obj.title);
            if (obj.isRequire) {
                [requireIOPaths addObject:obj];
            } else {
                [optionalIOPaths addObject:obj];
            }
        }];
    }
    
    if (self.subcommands.count) {
        CCPrintf(CCStyleUnderline, @"%@:\n", CLCurrentLanguage.helpCommands);
        CCPrintf(0, @"\n");
        [self.subcommands.allKeys cl_sort:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
            return [obj1 compare:obj2];
        } enumerate:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CLCommand *command = self.subcommands[obj];
            NSString *title = command.title;
            
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorGreen, title);
            CCPrintf(0, [NSString cl_stringWithSpace:maxKey + 3 - strlen(title.UTF8String)]);
            if (command.explain) {
                CCPrintf(0, command.explain);
            }
            CCPrintf(0, @"\n");
        }];
        CCPrintf(0, @"\n");
    }
    
    const NSUInteger REQUIRE_COUNT = requireQueryKeys.count + requireIOPaths.count;
    if (REQUIRE_COUNT) {
        NSUInteger printedCount = 0;
        
        CCPrintf(CCStyleUnderline, @"%@:\n", CLCurrentLanguage.helpRequires);
        CCPrintf(0, @"\n");
        
        printedCount += [requireQueryKeys cl_sort:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        } enumerate:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            CLQuery *query = self.queries[obj];
            NSString *title = query.title;
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorGreen, title);
            CCPrintf(0, [NSString cl_stringWithSpace:maxKey + 3 - strlen(title.UTF8String)]);
            CCPrintf(0, query.subtitle);
            CCPrintf(0, @"\n");
        }];
        
        if (printedCount && (REQUIRE_COUNT - printedCount)) {
            CCPrintf(0, @"\n");
        }
        
        printedCount += [requireIOPaths cl_sort:nil enumerate:^(CLIOPath *obj, NSUInteger idx, BOOL *stop) {
            NSString *title = obj.title;
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorGreen, title);
            CCPrintf(0, [NSString cl_stringWithSpace:maxKey + 3 - strlen(title.UTF8String)]);
            CCPrintf(0, obj.subtitle);
            CCPrintf(0, @"\n");
        }];
        
        CCPrintf(0, @"\n");
    }
    
    const NSUInteger OPTIONAL_COUNT = self.flags.count + self.predefineFlags.count + optionalQueryKeys.count + optionalIOPaths.count;
    if (OPTIONAL_COUNT) {
        NSUInteger printedCount = 0;
        
        CCPrintf(CCStyleUnderline, @"%@:\n", CLCurrentLanguage.helpOptions);
        CCPrintf(0, @"\n");
        
        printedCount += [optionalQueryKeys cl_sort:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        } enumerate:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CLQuery *query = self.queries[obj];
            NSString *title = query.title;
            
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorBlue, title);
            CCPrintf(0, [NSString cl_stringWithSpace:maxKey + 3 - strlen(title.UTF8String)]);
            CCPrintf(0, query.subtitle);
            CCPrintf(0, @"\n");
        }];
        
        if (printedCount && (OPTIONAL_COUNT - printedCount)) {
            CCPrintf(0, @"\n");
        }
        
        printedCount += [self.flags.allValues cl_sort:^NSComparisonResult(CLFlag *obj1, CLFlag *obj2) {
            return [obj1.key compare:obj2.key];
        } enumerate:^(CLFlag *obj, NSUInteger idx, BOOL *stop) {
            NSString *title = obj.title;
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorBlue, title);
            CCPrintf(0, [NSString cl_stringWithSpace:maxKey + 3 - strlen(title.UTF8String)]);
            CCPrintf(0, obj.subtitle);
            CCPrintf(0, @"\n");
        }];
        
        if (printedCount && (OPTIONAL_COUNT - printedCount)) {
            CCPrintf(0, @"\n");
        }
        
        printedCount += [optionalIOPaths cl_sort:nil enumerate:^(CLIOPath *obj, NSUInteger idx, BOOL *stop) {
            NSString *title = obj.title;
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorBlue, title);
            CCPrintf(0, [NSString cl_stringWithSpace:maxKey + 3 - strlen(title.UTF8String)]);
            CCPrintf(0, obj.subtitle);
            CCPrintf(0, @"\n");
        }];
        
        if (printedCount && (OPTIONAL_COUNT - printedCount)) {
            CCPrintf(0, @"\n");
        }
        
        printedCount += [self.predefineFlags.allValues cl_sort:^NSComparisonResult(CLFlag *obj1, CLFlag *obj2) {
            return [obj1.key compare:obj2.key];
        } enumerate:^(CLFlag *obj, NSUInteger idx, BOOL *stop) {
            NSString *title = obj.title;
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorBlue, title);
            CCPrintf(0, [NSString cl_stringWithSpace:maxKey + 3 - strlen(title.UTF8String)]);
            CCPrintf(0, obj.subtitle);
            CCPrintf(0, @"\n");
        }];
        
        CCPrintf(0, @"\n");
    }
}

@end
