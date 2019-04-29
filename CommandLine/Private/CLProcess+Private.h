//
//  CLProcess+Private.h
//  CommandLine
//
//  Created by Magic-Unique on 2019/4/28.
//

#import "CLProcess.h"

@interface CLProcess (Private)

- (instancetype)initWithCommands:(NSArray *)commands
                         queries:(NSDictionary *)queries
                           flags:(id)flags
                           paths:(NSArray *)paths
                           error:(NSError *)error;

@end
