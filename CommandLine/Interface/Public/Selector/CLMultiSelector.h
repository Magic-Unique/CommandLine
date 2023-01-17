//
//  CLMultiSelector.h
//  CommandLineDemo
//
//  Created by 冷秋 on 2019/10/20.
//  Copyright © 2023 Magic-Unique. All rights reserved.
//

#import "CLSelector.h"

@interface CLMultiSelector : CLSelector

- (NSArray *)select:(NSArray *)list render:(NSString *(^)(id item))render;

@end
