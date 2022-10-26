//
//  CLDefaultHelpBannerProvider.m
//  Pods
//
//  Created by 吴双 on 2022/10/24.
//

#import "CLDefaultHelpBannerProvider.h"
#import <CommandLine/ANSI.h>
#import "CLCommandInfo.h"

//static NSString *CLStringRepeat(NSString *str, NSUInteger count) {
//    NSMutableString *string = [NSMutableString string];
//    for (NSUInteger i = 0; i < count; i++) {
//        [string appendString:str];
//    }
//    return [string copy];
//}

#define CL_TAB @"    "

@interface CLDefaultHelpRow : NSObject

@property NSString *title;
@property NSString *subtitle;
@property NSString *note;

@property CCStyle leftStyle;
@property CCStyle rightStyle;

@end @implementation CLDefaultHelpRow @end


@interface CLDefaultHelpSection : NSObject

@property (nonatomic, strong) NSString *kind;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *note;

@property (nonatomic, strong) NSArray<CLDefaultHelpRow *> *tableRows;

@end

@implementation CLDefaultHelpSection

- (NSString *)toBanner:(NSUInteger)titleLength subtitle:(BOOL)subtitle {
    NSMutableArray *list = [NSMutableArray array];
    if (self.kind) {
        [list addObject:[NSString stringWithFormat:@"%@:", self.kind].ansi.underline.ansiText];
    }
    if (self.title) {
        [list addObject:[NSString stringWithFormat:@"%@%@", CL_TAB, self.title]];
    }
    if (self.note) {
        [list addObject:[NSString stringWithFormat:@"%@%@", CL_TAB, self.note]];
    }
    if (self.tableRows.count) {
        BOOL shortName = subtitle;
        NSUInteger maxTitleLength = titleLength;
        NSMutableArray *lines = [NSMutableArray array];
        for (CLDefaultHelpRow *row in self.tableRows) {
            NSMutableString *left = [NSMutableString string];
            if (shortName) {
                [left appendString:row.subtitle ?: @""];
            }
            [left appendString:row.title];
            NSUInteger step = maxTitleLength + 4 + 2 - left.length;
            for (NSUInteger i = 0; i < step; i++) {
                [left appendString:@" "];
            }

            NSMutableString *line = [NSMutableString string];
            [line appendString:CL_TAB];
            [line appendString:CCText(row.leftStyle, left)];
            [line appendString:CCText(row.rightStyle, row.note ?: @"")];
            [lines addObject:line];
        }
        [list addObject:[lines componentsJoinedByString:@"\n"]];
    }
    return [list componentsJoinedByString:@"\n\n"];
}

@end



@interface CLDefaultHelpTable : NSObject

@property NSArray<CLDefaultHelpSection *> *sections;

@end

@implementation CLDefaultHelpTable

- (NSString *)toBanner {
    NSUInteger maxTitleLength = 0;
    BOOL subtitle = NO;
    for (CLDefaultHelpSection *section in self.sections) {
        for (CLDefaultHelpRow *row in section.tableRows) {
            NSUInteger titleLength = row.title.length + row.subtitle.length;
            maxTitleLength = MAX(titleLength, maxTitleLength);
            
            if (row.subtitle.length) {
                subtitle = YES;
            }
        }
    }
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:self.sections.count];
    [self.sections enumerateObjectsUsingBlock:^(CLDefaultHelpSection *section, NSUInteger idx, BOOL * _Nonnull stop) {
        [list addObject:[section toBanner:maxTitleLength subtitle:subtitle]];
    }];
    [list addObject:@""];
    return [list componentsJoinedByString:@"\n\n"];
}

@end



@implementation CLDefaultHelpBannerProvider

- (NSArray<CLArgumentInfo *> *)sortedArguments:(NSMutableDictionary<NSString *, CLArgumentInfo *> *)map {
    return [map.allValues
            sortedArrayUsingComparator:^NSComparisonResult(CLArgumentInfo *obj1, CLArgumentInfo *obj2) {
        if (obj1.isArray) {
            return NSOrderedDescending;
        } else if (obj2.isArray) {
            return NSOrderedAscending;
        }
        return obj1.index > obj2.index;
    }];
}

- (NSString *)helpBannerForPrecommands:(NSArray *)precommands commandInfo:(CLCommandInfo *)commandInfo error:(NSError *)error {
    NSMutableArray *sections = [NSMutableArray array];
    [self __genUsage:sections precommands:precommands commandInfo:commandInfo];
    [self __genSubcommands:sections precommands:precommands commandInfo:commandInfo];
    [self __genArguments:sections precommands:precommands commandInfo:commandInfo];
    [self __genOptions:sections precommands:precommands commandInfo:commandInfo];
    [self __genDefaultOptions:sections precommands:precommands commandInfo:commandInfo];
    CLDefaultHelpTable *table = [[CLDefaultHelpTable alloc] init];
    table.sections = sections;
    return [table toBanner];
}

- (void)__genUsage:(NSMutableArray<CLDefaultHelpSection *> *)sections
       precommands:(NSArray *)precommands
       commandInfo:(CLCommandInfo *)commandInfo {
    
    if (commandInfo.runnable) {
        CLDefaultHelpSection *section = [[CLDefaultHelpSection alloc] init];
        section.title = ({
            NSMutableString *title = [NSMutableString string];
            [title appendString:@"$ "];
            [title appendString:[precommands componentsJoinedByString:@" "].ansi.green.ansiText];
            if (commandInfo.options.count) {
                [title appendString:@" [Options]".ansi.yellow.ansiText];
            }
            if (commandInfo.arguments.count) {
                NSArray *arguments = [self sortedArguments:commandInfo.arguments];
                for (CLArgumentInfo *info in arguments) {
                    NSString *suf = info.isArray ? @" ..." : @"";
                    if (info.isRequired) {
                        [title appendString:CCText(CCStyleForegroundColorPurple, @" <%@%@>", info.name, suf)];
                    } else {
                        [title appendString:CCText(CCStyleForegroundColorYellow, @" [%@%@]", info.name, suf)];
                    }
                }
            }
            title;
        });
        if (commandInfo.note) {
            section.note = [NSString stringWithFormat:@"  %@", commandInfo.note];
        }
        [sections addObject:section];
    }
    
    if (commandInfo.subcommands.count) {
        CLDefaultHelpSection *section = [[CLDefaultHelpSection alloc] init];
        section.title = ({
            NSMutableString *title = [NSMutableString string];
            [title appendString:@"$ "];
            [title appendString:[precommands componentsJoinedByString:@" "].ansi.green.ansiText];
            [title appendString:@" <COMMAND>".ansi.green.ansiText];
            title;
        });
        if (commandInfo.note) {
            section.note = [NSString stringWithFormat:@"  %@", commandInfo.note];
        }
        [sections addObject:section];
    }
    
    sections.firstObject.kind = @"Usage";
}

- (void)__genSubcommands:(NSMutableArray *)sections precommands:(NSArray *)precommands commandInfo:(CLCommandInfo *)commandInfo {
    if (!commandInfo.subcommands.count) {
        return;
    }
    CLDefaultHelpSection *section = [[CLDefaultHelpSection alloc] init];
    section.kind = @"Commands";
    NSMutableArray *rows = [NSMutableArray arrayWithCapacity:commandInfo.subcommands.count];
    for (CLCommandInfo *item in commandInfo.subcommands.allValues) {
        CLDefaultHelpRow *row = [[CLDefaultHelpRow alloc] init];
        row.title = [NSString stringWithFormat:@"+ %@", item.name];
        row.note = item.note;
        row.leftStyle = CCStyleForegroundColorGreen;
        [rows addObject:row];
    }
    section.tableRows = rows;
    
    [sections addObject:section];
}

- (void)__genArguments:(NSMutableArray *)sections precommands:(NSArray *)precommands commandInfo:(CLCommandInfo *)commandInfo {
    if (!commandInfo.arguments.count) {
        return;
    }
    
    NSArray *arguments = [self sortedArguments:commandInfo.arguments];
    CLDefaultHelpSection *section = [[CLDefaultHelpSection alloc] init];
    section.kind = @"Arguments";
    NSMutableArray *rows = [NSMutableArray array];
    for (CLArgumentInfo *argument in arguments) {
        CLDefaultHelpRow *row = [[CLDefaultHelpRow alloc] init];
        NSString *suf = argument.isArray ? @" ..." : @"";
        if (argument.isRequired) {
            row.title = [NSString stringWithFormat:@"<%@%@>", argument.name, suf];
            row.leftStyle = CCStyleForegroundColorPurple;
        } else {
            row.title = [NSString stringWithFormat:@"[%@%@]", argument.name, suf];
            row.leftStyle = CCStyleForegroundColorYellow;
        }
        row.note = argument.note;
        [rows addObject:row];
    }
    section.tableRows = rows;
    [sections addObject:section];
}

- (void)__genOptions:(NSMutableArray *)sections precommands:(NSArray *)precommands commandInfo:(CLCommandInfo *)commandInfo {
    if (!commandInfo.options.count) {
        return;
    }
    
    NSMutableArray<CLOptionInfo *> *required = [NSMutableArray array];
    NSMutableArray<CLOptionInfo *> *optional = [NSMutableArray array];
    NSMutableArray<CLOptionInfo *> *flagbool = [NSMutableArray array];
    
    BOOL shortName = NO;
    
    for (CLOptionInfo *item in commandInfo.options.allValues) {
        if (item.isBOOL) {
            [flagbool addObject:item];
        }
        else if (item.isRequired) {
            [required addObject:item];
        }
        else {
            [optional addObject:item];
        }
        if (item.shortName) {
            shortName = YES;
        }
    }
    
    __auto_type SortArray = ^(NSMutableArray<CLOptionInfo *> *options) {
        [options sortUsingComparator:^NSComparisonResult(CLOptionInfo * obj1, CLOptionInfo *obj2) {
            return [obj1.name compare:obj2.name];
        }];
    };
    SortArray(required);
    SortArray(optional);
    SortArray(flagbool);
    
    __auto_type GenerateLines = ^(NSArray<CLOptionInfo *> *options, BOOL shortName, NSMutableArray<CLDefaultHelpRow *> *rows) {
        for (CLOptionInfo *item in options) {
            CLDefaultHelpRow *row = [[CLDefaultHelpRow alloc] init];
            if (shortName) {
                if (item.shortName) {
                    row.subtitle = [NSString stringWithFormat:@"-%c|", item.shortName];
                } else {
                    row.subtitle = @"   ";
                }
            }
            row.title = ({
                NSMutableString *title = [NSMutableString string];
                [title appendFormat:@"--%@", item.name];
                if (!item.isBOOL) {
                    [title appendFormat:@" <%@>", item.placeholder ?: item.name];
                }
                title;
            });
            row.leftStyle = CCStyleForegroundColorBlue;
            row.note = item.note ?: @"";
            [rows addObject:row];
        }
    };
    
    if (required.count) {
        CLDefaultHelpSection *requiresSection = [[CLDefaultHelpSection alloc] init];
        requiresSection.kind = @"Require";
        NSMutableArray *rows = [NSMutableArray array];
        GenerateLines(required, shortName, rows);
        requiresSection.tableRows = rows;
        [sections addObject:requiresSection];
    }
    
    if (optional.count + flagbool.count) {
        CLDefaultHelpSection *optionsSection = [[CLDefaultHelpSection alloc] init];
        optionsSection.kind = @"Options";
        NSMutableArray *rows = [NSMutableArray array];
        GenerateLines(optional, shortName, rows);
        GenerateLines(flagbool, shortName, rows);
        optionsSection.tableRows = rows;
        [sections addObject:optionsSection];
    }
}

- (void)__genDefaultOptions:(NSMutableArray *)sections precommands:(NSArray *)precommands commandInfo:(CLCommandInfo *)commandInfo {
    
    CLDefaultHelpSection *section = [[CLDefaultHelpSection alloc] init];
    NSMutableArray<CLDefaultHelpRow *> *rows = [NSMutableArray array];
    [[CLOptionInfo defaultOptions] enumerateObjectsUsingBlock:^(CLOptionInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CLDefaultHelpRow *row = [[CLDefaultHelpRow alloc] init];
        row.title = [NSString stringWithFormat:@"--%@", obj.name];
        row.note = obj.note;
        row.leftStyle = CCStyleForegroundColorBlue;
        [rows addObject:row];
    }];
    section.tableRows = rows;
    [sections addObject:section];
}

@end
