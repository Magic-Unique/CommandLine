//
//  CLCommand+Handler.m
//  CommandLine
//
//  Created by 冷秋 on 2018/6/4.
//

#import "CLCommand+Process.h"
#import "CLQuery.h"
#import "CLFlag.h"
#import "CLCommand+Print.h"
#import "CLError.h"
#import "CCText.h"
#import "CLProcess.h"

@interface CLCommand ()

@property (nonatomic, strong, readonly) NSMutableArray *mRequirePath;

@end

@implementation CLCommand (Process)

- (int)_process:(CLProcess *)process {
    NSAssert((self.task || self.subcommands.count),
             @"The command `%@` should contains a task or a subcommand", [process.commands componentsJoinedByString:@" "]);
    
    if (CLCommand.mainCommand == self && [process flag:@"version"]) {
        CCPrintf(0, @"%@\n", [CLCommand version]);
        return EXIT_SUCCESS;
    }
    if ([process flag:@"help"]) {
        [self printHelpInfo];
        return EXIT_SUCCESS;
    }
    
    if (self.forwardingSubcommand) {
        return [self.forwardingSubcommand _process:process];
    }
    
    if (self.task == nil) {
        [self printHelpInfo];
        return EXIT_SUCCESS;
    }
    
    if (process.error) {
        CCPrintf(0, process.error.userInfo[CLErrorPrintInformationKey]);
        CCPrintf(0, @"\n");
        return EXIT_FAILURE;
    }
    
    NSArray *_missingQueries = [self _missingQueriesInProcess:process];
    if (_missingQueries.count) {
        [self printHelpInfo];
        return EXIT_FAILURE;
    }
    
    NSUInteger _missingPaths = [self _missingIOPathCountInProcess:process];
    if (_missingPaths > 0) {
        [self printHelpInfo];
        return EXIT_FAILURE;
    }
    
    return self.task(self, process);
}

- (NSArray *)_missingQueriesInProcess:(CLProcess *)process {
    NSMutableArray *queries = [NSMutableArray array];
    [self.queries enumerateKeysAndObjectsUsingBlock:^(NSString *key, CLQuery *obj, BOOL *stop) {
        if (obj.isOptional == NO && process.queries[key] == nil) {
            [queries addObject:obj];
        }
    }];
    if (queries.count) {
        return [queries copy];
    } else {
        return nil;
    }
}

- (NSUInteger)_missingIOPathCountInProcess:(CLProcess *)process {
    if (self.mRequirePath.count > process.paths.count) {
        return self.mRequirePath.count - process.paths.count;
    } else {
        return 0;
    }
}

@end
