//
//  CLSelector.h
//  CommandLineDemo
//
//  Created by 冷秋 on 2019/10/20.
//  Copyright © 2019 unique. All rights reserved.
//

#import "CLInterface.h"
#import "ANSI.h"

typedef NSString *(^CLSelectorRender)(NSString *item, BOOL highlight, BOOL selected);

@interface CLSelector : CLInterface

@property (nonatomic, copy) CLSelectorRender render;

@property (nonatomic, assign) CCStyle normalStyle;

@property (nonatomic, assign) CCStyle highlightStyle;

@property (nonatomic, assign) CCStyle selectedStyle;

+ (instancetype)selector;

+ (instancetype)selectorWithRender:(CLSelectorRender)render;

- (id)doSelect:(id (^)(void))selection;

@end
