//
//  CLDemo.h
//  CommandLineDemo
//
//  Created by 冷秋 on 2019/10/18.
//  Copyright © 2019 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommandLine/ANSI.h>

@interface CLDemo : NSObject

+ (NSUInteger)select:(NSArray *)list
        defaultIndex:(NSUInteger)defaultIndex
              normal:(CCStyle)normal
           highlight:(CCStyle)highlight
              render:(NSString *(^)(id item, NSUInteger index, BOOL highlight))render;

+ (NSArray *)multiSelect:(NSArray *)list
                  normal:(CCStyle)normal
               highlight:(CCStyle)highlight
                selected:(CCStyle)selected
                  render:(NSString *(^)(id item, NSUInteger index, BOOL highlight, BOOL selected))render;

@end
