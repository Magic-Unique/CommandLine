//
//  CLSelector.m
//  CommandLineDemo
//
//  Created by 冷秋 on 2019/10/20.
//  Copyright © 2023 Magic-Unique. All rights reserved.
//

#import "CLSelector.h"
#include <stdio.h>
#include <termios.h>
#include <unistd.h>
#include <errno.h>

int getattr(struct termios *oldt)
{
    if ( -1 == tcgetattr(STDIN_FILENO, oldt) )
    {
        perror("Cannot get standard input description");
        return 1;
    }
    return 0;
}

int setattr(struct termios newt)
{
    newt.c_lflag &= ~(ICANON | ECHO | ISIG);
    newt.c_cc[VTIME] = 0;
    newt.c_cc[VMIN] = 1;
    tcsetattr(STDIN_FILENO, TCSANOW, &newt);
    return 0;
}

int resetattr(struct termios *oldt)
{
    tcsetattr(STDIN_FILENO, TCSANOW, oldt);
    return 0;
}

@implementation CLSelector

+ (instancetype)selector {
    return [self selectorWithRender:nil];
}

+ (instancetype)selectorWithRender:(CLSelectorRender)render {
    CLSelector *selector = [[self alloc] init];
    if (render) {
        selector.render = render;
    }
    return selector;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _normalStyle = CCStyleLight;
        _highlightStyle = CCStyleBold;
        _selectedStyle = CCStyleForegroundColorDarkGreen;
    }
    return self;
}

- (id)doSelect:(id (^)(void))selection {
    struct termios oldt;
    getattr(&oldt);
    setattr(oldt);
    [CLCursor hide];
    id object = selection();
    [CLCursor show];
    resetattr(&oldt);
    return object;
}

@end
