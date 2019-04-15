//
//  CLCommand+Handler.m
//  CommandLine
//
//  Created by 冷秋 on 2018/6/4.
//

#import "CLCommand+Process.h"
#import "CLRequest.h"
#import "CLQuery.h"
#import "CLFlag.h"
#import "CLCommand+Print.h"
#import "CLResponse+Private.h"
#import "CLRequest+Private.h"
#import "CLError.h"
#import "CCText.h"

@interface CLCommand ()

@property (nonatomic, strong, readonly) NSMutableArray *mRequirePath;

@end

@implementation CLCommand (Process)

- (CLResponse *)_processRequest:(CLRequest *)request {
    NSAssert((self.task || self.subcommands.count), @"The command `%@` should contains a task or a subcommand", [request.commands componentsJoinedByString:@" "]);
    
    [CLRequest setVerbose:[request flag:[CLFlag verbose].key]];
    
    if (CLCommand.mainCommand == self && [request flag:@"version"]) {
        CCPrintf(0, @"%@\n", [CLCommand version]);
        return [CLResponse succeed:@{@"mode":@"version"}];
    }
    if ([request flag:@"help"]) {
        [self printHelpInfo];
        return [CLResponse responseWithHelpCommands:request.commands];
    }
    
    if (self.forwardingSubcommand) {
        return [self.forwardingSubcommand _processRequest:request];
    }
    
    if (self.task == nil) {
        [self printHelpInfo];
        return [CLResponse responseWithHelpCommands:request.commands];
    }
    
    if (request.error) {
        CCPrintf(0, request.error.userInfo[CLErrorPrintInformationKey]);
        CCPrintf(0, @"\n");
        return [CLResponse responseWithHelpCommands:request.commands];
    }
    
    NSArray *_missingQueries = [self _missingQueriesInRequest:request];
    if (_missingQueries.count) {
        [self printHelpInfo];
        return [CLResponse responseWithMissingArguments:[_missingQueries valueForKeyPath:@"key"]];
    }
    
    NSUInteger _missingPaths = [self _missingIOPathCountInRequest:request];
    if (_missingPaths > 0) {
        [self printHelpInfo];
        return [CLResponse responseWithMissingPathsCount:_missingPaths];
    }
    
    CLResponse *response = self.task(self, request);
    if (!response) {
        response = [CLResponse succeed:nil];
    }
    return response;
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
