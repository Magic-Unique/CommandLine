//
//  CLCommand+Request.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/20.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLCommand+Request.h"
#import "NSString+CommandLine.h"

@implementation CLCommand (Request)

+ (NSArray *)getAbbrs:(NSString *)string {
    NSString *value = [string substringFromIndex:1];
    NSMutableArray *abbrs = [NSMutableArray arrayWithCapacity:value.length];
    for (NSUInteger i = 0; i < value.length; i++) {
        NSString *abbr = [value substringWithRange:NSMakeRange(i, 1)];
        [abbrs addObject:abbr];
    }
    return [abbrs copy];
}

- (void)_enumerateQueriesUsingBlock:(void(^)(CLQuery *query, BOOL *stop))block {
    CLCommand *command = self;
    __block BOOL _stop = NO;
    while (command) {
        [command.queries.allValues enumerateObjectsUsingBlock:^(CLQuery * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            block(obj, &_stop);
            *stop = _stop;
        }];
        if (_stop) {
            break;
        }
        command = command.supercommand;
    }
}

- (void)_enumerateFlagsUsingBlock:(void(^)(CLFlag *flag, BOOL *stop))block {
    CLCommand *command = self;
    __block BOOL _stop = NO;
    while (command) {
        [command.flags.allValues enumerateObjectsUsingBlock:^(CLFlag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            block(obj, &_stop);
            *stop = _stop;
        }];
        if (_stop) {
            break;
        }
        command = command.supercommand;
    }
}

- (CLExplain *)_explainWithKey:(NSString *)key next:(NSString *)next {
    __block CLExplain *explain = nil;
    if (next && CLArgumentIsKeyOrAbbr(next) == NO) {
        [self _enumerateQueriesUsingBlock:^(CLQuery *query, BOOL *stop) {
            if ([query.key isEqualToString:key]) {
                explain = query;
                *stop = YES;
            }
        }];
        if (explain) {
            return explain;
        }
    }
    [self _enumerateFlagsUsingBlock:^(CLFlag *flag, BOOL *stop) {
        if ([flag.key isEqualToString:key]) {
            explain = flag;
            *stop = YES;
        }
    }];
    return explain;
}

- (CLExplain *)_explainWithAbbr:(char)abbr next:(NSString *)next {
    __block CLExplain *explain = nil;
    if (next && CLArgumentIsKeyOrAbbr(next) == NO) {
        [self _enumerateQueriesUsingBlock:^(CLQuery *query, BOOL *stop) {
            if (query.abbr == abbr) {
                explain = query;
                *stop = YES;
            }
        }];
        if (explain) {
            return explain;
        }
    }
    [self _enumerateFlagsUsingBlock:^(CLFlag *flag, BOOL *stop) {
        if (flag.abbr == abbr) {
            explain = flag;
            *stop = YES;
        }
    }];
    return explain;
}

+ (CLRequest *)requestWithArguments:(NSArray<NSString *> *)arguments {
    if (arguments.count == 0) {
        return nil;
    }
    
    if (arguments.count == 1) {
        CLCommand *sharedCommand = CLCommand.main;
        return [CLRequest requestWithCommands:@[sharedCommand.command] queries:nil flags:nil paths:nil];
    }
    
    CLCommand *command = [CLCommand main];
    
    NSMutableArray *_arguments = [arguments mutableCopy];
    NSMutableArray *_commands = [NSMutableArray array]; [_commands addObject:command.command];
    NSMutableDictionary *_queries = [NSMutableDictionary dictionary];
    NSMutableSet *_flags = [NSMutableSet set];
    NSMutableArray *_paths = [NSMutableArray array];
    NSError *parseError = nil;
    
    BOOL confirmedCommand = NO;
    
    for (NSUInteger i = 1; i < _arguments.count; i++) {
        NSString *current = _arguments[i];
        NSString *next = i + 1 < _arguments.count ? _arguments[i + 1] : nil;
        
        if (CLArgumentIsAbbr(current) && current.length > 2) {
            current = [current substringFromIndex:1];
            NSMutableArray *subarray = [NSMutableArray arrayWithCapacity:current.length];
            for (NSUInteger j = 0; j < current.length; j++) {
                [subarray addObject:[@"-" stringByAppendingString:[current substringWithRange:NSMakeRange(j, 1)]]];
            }
            [_arguments replaceObjectsInRange:NSMakeRange(i, 1) withObjectsFromArray:subarray];
            i--;
            continue;
        }
        
        if (CLArgumentIsKeyOrAbbr(current) == NO) {
            CLCommand *subcmd = command.subcommands[current];
            if (confirmedCommand == NO && subcmd) {
                [_commands addObject:current];
                command = subcmd;
            } else {
                confirmedCommand = YES;
                [_paths addObject:current];
            }
        } else {
            confirmedCommand = YES;
            
            CLExplain *explain = nil;
            NSString *_flag = nil;
            
            if (CLArgumentIsAbbr(current)) {
                //  abbr/abbrs/abbr(s)+query
                explain = [command _explainWithAbbr:CLGetAbbrFromArgument(current) next:next];
                _flag = [NSString stringWithFormat:@"%c", CLGetAbbrFromArgument(current)];
            } else {
                //  query/flags
                explain = [command _explainWithKey:CLGetKeyFromArgument(current) next:next];
                _flag = CLGetKeyFromArgument(current);
            }
            
            if ([explain isMemberOfClass:[CLQuery class]]) {
                CLQuery *query = (CLQuery *)explain;
                if ([query predicateForString:next]) {
                    if (query.isMultiable) {
                        NSMutableArray *array = ({
                            NSMutableArray *array = _queries[query.key];
                            if (!array) {
                                array = [NSMutableArray array];
                                _queries[query.key] = array;
                            }
                            array;
                        });
                        [array addObject:next];
                    } else {
                        _queries[query.key] = next;
                    }
                    i++;
                } else {
                    parseError = [NSError errorWithDomain:@""
                                                     code:__LINE__
                                                 userInfo:@{}];
                }
            } else if ([explain isMemberOfClass:[CLFlag class]]) {
                CLFlag *flag = (CLFlag *)explain;
                [_flags addObject:flag.key];
            } else {
                // no define
                [_flags addObject:_flag];
            }
        }
    }
    
    [command.queries enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CLQuery * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.isOptional && obj.defaultValue && _queries[obj.key] == nil) {
            if (obj.isMultiable && ![obj.defaultValue isKindOfClass:[NSArray class]]) {
                _queries[obj.key] = @[obj.defaultValue];
            } else {
                _queries[obj.key] = obj.defaultValue;
            }
        }
    }];
    
    if (parseError) {
        return [CLRequest illegallyrequestWithCommands:_commands];
    }
    
    NSArray *commands = _commands.count ? [_commands copy] : nil;
    NSDictionary *queries = _queries.count ? [_queries copy]: nil;
    NSSet *flags = _flags.count ? [_flags copy] : nil;
    NSArray *paths = _paths.count ? [_paths copy] : nil;
    return [CLRequest requestWithCommands:commands queries:queries flags:flags paths:paths];
}

@end
