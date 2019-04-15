//
//  CLCommand+Request.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/20.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLCommand+Request.h"
#import "CLQuery.h"
#import "CLFlag.h"
#import "CLRequest.h"
#import "NSString+CommandLine.h"
#import "NSError+CommandLine.h"
#import "CLRequest+Private.h"

@implementation CLCommand (Request)

+ (CLCommand *)commandWithArguments:(NSMutableArray *)arguments {
    if (arguments.count == 0) {
        return nil;
    }
    
    if (arguments.count == 1) {
        return [CLCommand mainCommand];
    }
    
    CLCommand *command = [CLCommand mainCommand];
    [arguments removeObjectAtIndex:0];
    
    // parse command level
    while (arguments.count) {
        NSString *current = arguments[0];
        
        if (![current cl_matches:@"^[a-zA-z][a-zA-z0-9\\-]*$"]) {
            break;
        }
        
        CLCommand *subcommand = command.subcommands[current];
        if (!subcommand) {
            break;
        }
        
        command = subcommand;
        [arguments removeObjectAtIndex:0];
    }
    
    return command;
}

- (CLRequest *)requestWithCommands:(NSArray *)commands arguments:(NSArray *)arguments {
    if (self.forwardingSubcommand) {
        return [self.forwardingSubcommand requestWithCommands:commands arguments:arguments];
    }
    NSMutableArray *_arguments = [arguments mutableCopy];
    
    NSMutableDictionary *_queries = [NSMutableDictionary dictionary];
    NSMutableSet *_flags = [NSMutableSet set];
    NSMutableArray *_paths = [NSMutableArray array];
    NSError *parseError = nil;
    
    // unfold mult-abbrs
    for (NSUInteger i = 0; i < _arguments.count; i++) {
        NSString *current = _arguments[i];
        if (CLArgumentIsAbbr(current) && current.length > 2) {
            current = [current substringFromIndex:1];
            NSMutableArray *subarray = [NSMutableArray arrayWithCapacity:current.length];
            for (NSUInteger j = 0; j < current.length; j++) {
                [subarray addObject:[@"-" stringByAppendingString:[current substringWithRange:NSMakeRange(j, 1)]]];
            }
            [_arguments replaceObjectsInRange:NSMakeRange(i, 1) withObjectsFromArray:subarray];
            i = i + subarray.count - 1;
        }
    }
    
    //  parse queries, flags, iopaths
    for (NSUInteger i = 0; i < _arguments.count; i++) {
        NSString *current = _arguments[i];
        NSString *next = (i + 1) < _arguments.count ? _arguments[i + 1] : nil;
        
        if (!CLArgumentIsKeyOrAbbr(current)) {
            [_paths addObject:current];
        } else {
            CLExplain *explain = nil;
            NSString *_flag = nil;
            
            if (CLArgumentIsAbbr(current)) {
                //  abbr/abbrs/abbr(s)+query
                explain = [self _explainWithAbbr:CLGetAbbrFromArgument(current) next:next];
                _flag = [NSString stringWithFormat:@"%c", CLGetAbbrFromArgument(current)];
            } else {
                //  query/flags
                explain = [self _explainWithKey:CLGetKeyFromArgument(current) next:next];
                _flag = CLGetKeyFromArgument(current);
            }
            
            if ([explain isMemberOfClass:[CLQuery class]]) {
                CLQuery *query = (CLQuery *)explain;
                if (![query predicateForString:next]) {
                    parseError = CLIllegalQueryError(query.key, next);
                    break;
                }
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
            } else if ([explain isMemberOfClass:[CLFlag class]]) {
                CLFlag *flag = (CLFlag *)explain;
                [_flags addObject:flag.key];
            } else {
                // no define
                if (!self.allowInvalidKeys) {
                    parseError = CLUnknowQueryError(_flag);
                    break;
                }
                [_flags addObject:_flag];
            }
        }
    }
    
    [self.queries enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CLQuery * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.isOptional && obj.defaultValue && _queries[obj.key] == nil) {
            if (obj.isMultiable && ![obj.defaultValue isKindOfClass:[NSArray class]]) {
                _queries[obj.key] = @[obj.defaultValue];
            } else {
                _queries[obj.key] = obj.defaultValue;
            }
        }
    }];
    
    if (parseError) {
        return [CLRequest illegallyRequestWithCommands:commands error:parseError];
    }
    
    NSDictionary *queries = _queries.count ? [_queries copy]: nil;
    NSSet *flags = _flags.count ? [_flags copy] : nil;
    NSArray *paths = _paths.count ? [_paths copy] : nil;
    return [CLRequest requestWithCommands:commands queries:queries flags:flags paths:paths];
}

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

@end
