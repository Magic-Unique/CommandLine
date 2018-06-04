//
//  CLCommand+Print.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/22.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLCommand+Print.h"
#import "NSString+CommandLine.h"
#import "CCText.h"
#import "CLConst.h"

@implementation CLCommand (Print)

- (NSArray *)commandNodes {
    CLCommand *command = self;
    NSMutableArray *nodes = [NSMutableArray arrayWithObject:command];
    while (command.supercommand) {
        command = command.supercommand;
        [nodes insertObject:command atIndex:0];
    }
    return [nodes copy];
}

- (NSArray *)commandPath {
    CLCommand *command = self;
    NSMutableArray *path = [NSMutableArray arrayWithObject:command.command];
    while (command.supercommand) {
        command = command.supercommand;
        [path insertObject:command.command atIndex:0];
    }
    return [path copy];
}

+ (void)printVersion {
    CCPrintf(0, @"%@\n", [self version]);
}

- (void)printHelpInfo {
    CCPrintf(CCStyleUnderline, @"%@:\n", CLHelpUsage);
    printf("\n");
    {
        NSString *commands = [[self commandPath] componentsJoinedByString:@" "];
        if (self.subcommands.count && self.task) {
            CCPrintf(0, @"    $ %@ [%@]\n", commands, CLHelpCommand);
        } else if (self.subcommands.count == 0 && self.task) {
            CCPrintf(0, @"    $ %@\n", commands);
        } else if (self.subcommands.count && self.task == nil) {
            CCPrintf(0, @"    $ %@ <%@>\n", commands, CLHelpCommand);
        } else {
            NSAssert(NO, @"The command `%@` should contains a task or a subcommand", self.command);
        }
        printf("\n");
        
        if (self.explain.length) {
            CCPrintf(0, @"    %@\n", self.explain);
            printf("\n");
        }
    }
    
    __block NSUInteger maxKey = 0;
    void (^CLCompareMaxLength)(NSString *string) = ^(NSString *string) {
        if (strlen(string.UTF8String) > maxKey) {
            maxKey = string.length;
        }
    };
    NSMutableArray *optionalQueryKeys = [NSMutableArray array];
    NSMutableArray *requireQueryKeys = [NSMutableArray array];
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
    }
    
    if (self.subcommands.count) {
        CCPrintf(CCStyleUnderline, @"%@:\n", CLHelpCommands);
        printf("\n");
        [[self.subcommands.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CLCommand *command = self.subcommands[obj];
            NSString *title = command.title;
            
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorGreen, title);
            CCPrintf(0, [NSString cl_stringWithSpace:maxKey + 3 - strlen(title.UTF8String)]);
            if (command.explain) {
                CCPrintf(0, command.explain);
            }
            printf("\n");
        }];
        printf("\n");
    }
    
    if (requireQueryKeys.count) {
        CCPrintf(CCStyleUnderline, @"%@:\n", CLHelpRequires);
        printf("\n");
        [[requireQueryKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CLQuery *query = self.queries[obj];
            NSString *title = query.title;
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorGreen, title);
            CCPrintf(0, [NSString cl_stringWithSpace:maxKey + 3 - strlen(title.UTF8String)]);
            CCPrintf(0, query.subtitle);
            printf("\n");
        }];
        printf("\n");
    }
    
    if (self.flags.count + optionalQueryKeys.count) {
        CCPrintf(CCStyleUnderline, @"%@:\n", CLHelpOptions);
        printf("\n");
        [[optionalQueryKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CLQuery *query = self.queries[obj];
            NSString *title = query.title;
            
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorBlue, title);
            CCPrintf(0, [NSString cl_stringWithSpace:maxKey + 3 - strlen(title.UTF8String)]);
            CCPrintf(0, query.subtitle);
            printf("\n");
        }];
        
        if (optionalQueryKeys.count && self.flags.count) {
            printf("\n");
        }
        
        [self.flags enumerateKeysAndObjectsUsingBlock:^(NSString *key, CLFlag *obj, BOOL *stop) {
            NSString *title = obj.title;
            
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorBlue, title);
            CCPrintf(0, [NSString cl_stringWithSpace:maxKey + 3 - strlen(title.UTF8String)]);
            CCPrintf(0, obj.subtitle);
            printf("\n");
        }];
        
        printf("\n");
    }
}

@end
