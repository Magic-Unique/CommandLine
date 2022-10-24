//
//  CLArgumentInfo.m
//  CommandLineDemo
//
//  Created by 吴双 on 2022/10/19.
//  Copyright © 2022 unique. All rights reserved.
//

#import "CLCommandInfo.h"

@implementation CLBaseInfo

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

@end

@implementation CLOptionInfo
- (BOOL)isBOOL { return [self.type isEqualToString:@"CLBool"]; }
- (BOOL)nonnull { _isRequired = YES; return _isRequired; }
- (BOOL)nullable { _isRequired = NO; return _isRequired; }
@end

@implementation CLArgumentInfo @end



@implementation CLCommandInfo

- (CLOptionInfo *)optionInfoForName:(NSString *)name {
    return self.options[name];
}

- (CLOptionInfo *)optionInfoForShortName:(char)shortName {
    NSArray<CLOptionInfo *> *options = self.options.allValues;
    for (CLOptionInfo *item in options) {
        if (item.shortName == shortName) {
            return item;
        }
    }
    return nil;
}

@end
