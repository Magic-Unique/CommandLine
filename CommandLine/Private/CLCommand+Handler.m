//
//  CLCommand+Handler.m
//  CommandLine
//
//  Created by 吴双 on 2018/6/4.
//

#import "CLCommand+Handler.h"
#import "CLCommand+Print.h"
#import "CLResponse+Private.h"

@interface CLCommand ()

@property (nonatomic, strong, readonly) NSMutableArray *mRequirePath;

@end

@implementation CLCommand (Handler)

- (CLResponse *)_handleRequest:(CLRequest *)request {
    NSAssert((self.task || self.subcommands.count), @"The command `%@` should contains a task or a subcommand", [request.commands componentsJoinedByString:@" "]);
    
    if ([CLCommand sharedCommand] == self && [request.flags containsObject:@"version"]) {
        [CLCommand printVersion];
        return [CLResponse succeed:@{@"mode":@"version"}];
    }
    if ([request.flags containsObject:@"help"]) {
        [self printHelpInfo];
        return [CLResponse responseWithHelpCommands:request.commands];
    }
    
    if (self.task == nil) {
        [self printHelpInfo];
        return [CLResponse responseWithHelpCommands:request.commands];
    }
    
    NSArray *_missingQueries = [self _missingQueriesInRequest:request];
    if (_missingQueries.count) {
        // illegal
        [self printHelpInfo];
        return [CLResponse responseWithMissingArguments:[_missingQueries valueForKeyPath:@"key"]];
    }
    
    NSUInteger _missingPaths = [self _missingIOPathCountInRequest:request];
    if (_missingPaths > 0) {
        //  missing paths
        [self printHelpInfo];
        return [CLResponse responseWithMissingPathsCount:_missingPaths];
    }
    
    return self.task(self, request);
}

- (NSArray *)_missingQueriesInRequest:(CLRequest *)request {
    NSMutableArray *queries = [NSMutableArray array];
    [self.queries enumerateKeysAndObjectsUsingBlock:^(NSString *key, CLQuery *obj, BOOL *stop) {
        if (obj.isOptional == NO && request.queries[key] == nil) {
            [queries addObject:obj];
        }
    }];
    if (queries.count) {
        return [queries copy];
    } else {
        return nil;
    }
}

- (NSUInteger)_missingIOPathCountInRequest:(CLRequest *)request {
    if (self.mRequirePath.count > request.paths.count) {
        return self.mRequirePath.count - request.paths.count;
    } else {
        return 0;
    }
}

@end
