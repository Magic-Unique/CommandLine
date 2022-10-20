//
//  CLArgumentInfo.m
//  CommandLineDemo
//
//  Created by 吴双 on 2022/10/19.
//  Copyright © 2022 unique. All rights reserved.
//

#import "CLInfo.h"

@implementation CLBaseInfo

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

@end

@implementation CLOptionInfo @end
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
