//
//  CLCommand+Print.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/22.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLCommand+Print.h"
#import "NSString+CommandLine.h"
#import "NSArray+CommandLine.h"
#import "CCText.h"
#import "CLConst.h"

@implementation CLCommand (Print)

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
        [self.ioPaths enumerateObjectsUsingBlock:^(CLIOPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CLCompareMaxLength(obj.title);
            if (obj.isRequire) {
                [requireIOPaths addObject:obj];
            } else {
                [optionalIOPaths addObject:obj];
            }
        }];
    }
    
    if (self.subcommands.count) {
        CCPrintf(CCStyleUnderline, @"%@:\n", CLHelpCommands);
        printf("\n");
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
            printf("\n");
        }];
        printf("\n");
    }
    
    if (requireQueryKeys.count + requireIOPaths.count) {
        CCPrintf(CCStyleUnderline, @"%@:\n", CLHelpRequires);
        printf("\n");
        
        if (requireQueryKeys.count) {
            [requireQueryKeys cl_sort:^NSComparisonResult(NSString *obj1, NSString *obj2) {
                return [obj1 compare:obj2];
            } enumerate:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                CLQuery *query = self.queries[obj];
                NSString *title = query.title;
                CCPrintf(0, @"    ");
                CCPrintf(CCStyleForegroundColorGreen, title);
                CCPrintf(0, [NSString cl_stringWithSpace:maxKey + 3 - strlen(title.UTF8String)]);
                CCPrintf(0, query.subtitle);
                printf("\n");
            }];
        }
        
        if (requireIOPaths.count) {
            [requireIOPaths enumerateObjectsUsingBlock:^(CLIOPath *obj, NSUInteger idx, BOOL *stop) {
                NSString *title = obj.title;
                CCPrintf(0, @"    ");
                CCPrintf(CCStyleForegroundColorGreen, title);
                CCPrintf(0, [NSString cl_stringWithSpace:maxKey + 3 - strlen(title.UTF8String)]);
                CCPrintf(0, obj.subtitle);
                printf("\n");
            }];
        }
        
        printf("\n");
    }
    
    if (self.flags.count + optionalQueryKeys.count + optionalIOPaths.count) {
        CCPrintf(CCStyleUnderline, @"%@:\n", CLHelpOptions);
        printf("\n");
        [optionalQueryKeys cl_sort:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        } enumerate:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
        
        [self.flags.allValues cl_sort:^NSComparisonResult(CLFlag *obj1, CLFlag *obj2) {
            BOOL default1 = ((obj1 == [CLFlag help] || obj1 == [CLFlag verbose]));
            BOOL default2 = ((obj2 == [CLFlag help] || obj2 == [CLFlag verbose]));
            if (default1 != default2) {
                if (default1) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedAscending;
                }
            } else {
                return [obj1.key compare:obj2.key];
            }
        } enumerate:^(CLFlag *obj, NSUInteger idx, BOOL *stop) {
            NSString *title = obj.title;
            
            if (obj == [CLFlag help] && self.flags.count > 2) {
                CCPrintf(0, @"\n");
            }
            CCPrintf(0, @"    ");
            CCPrintf(CCStyleForegroundColorBlue, title);
            CCPrintf(0, [NSString cl_stringWithSpace:maxKey + 3 - strlen(title.UTF8String)]);
            CCPrintf(0, obj.subtitle);
            printf("\n");
        }];
        
        [optionalIOPaths enumerateObjectsUsingBlock:^(CLIOPath *obj, NSUInteger idx, BOOL *stop) {
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
