//
//  CLSelector.h
//  CommandLineDemo
//
//  Created by 冷秋 on 2019/10/20.
//  Copyright © 2019 unique. All rights reserved.
//

#import "CLInterface.h"
#import "ANSI.h"


typedef NS_ENUM(NSInteger, CLKey) {
    CLKeyNone       = 0,
    CLKeyReturn     = 10,
    CLKey_q         = 113,
    CLKeyUp         = -1,
    CLKeyDown       = -2,
    CLKeyRight      = -3,
    CLKeyLeft       = -4,
};

typedef NSString *(^CLSelectorRender)(NSString *item, BOOL highlight, BOOL selected);

@interface CLSelector : CLInterface

@property (nonatomic, copy) CLSelectorRender render;

@property (nonatomic, assign) CCStyle normalStyle;

@property (nonatomic, assign) CCStyle highlightStyle;

@property (nonatomic, assign) CCStyle selectedStyle;

+ (instancetype)selector;

+ (instancetype)selectorWithRender:(CLSelectorRender)render;

- (id)doSelect:(id (^)(void))selection;

- (CLKey)getKey;

@end
