//
//  CLSingleSelector.h
//  CommandLineDemo
//
//  Created by 冷秋 on 2019/10/19.
//  Copyright © 2019 unique. All rights reserved.
//

#import "CLSelector.h"

@interface CLSingleSelector : CLSelector

- (NSUInteger)select:(NSArray *)list render:(NSString *(^)(id item))render;

@end
