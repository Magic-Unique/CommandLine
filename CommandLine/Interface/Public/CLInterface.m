//
//  CLInterface.m
//  CommandLineDemo
//
//  Created by 冷秋 on 2019/10/19.
//  Copyright © 2019 unique. All rights reserved.
//

#import "CLInterface.h"

@implementation CLInterface

/*
 \033[nA    光标上移n行
 \033[nB    光标下移n行
 \033[nC    光标右移n行
 \033[nD    光标左移n行
 */

- (void)moveUp:(NSUInteger)steps {
    printf("\033[%luA", steps);
}

- (void)moveDown:(NSUInteger)steps {
    printf("\033[%luB", steps);
}

- (void)moveLeft:(NSUInteger)steps {
    printf("\033[%luD", steps);
}

- (void)moveRight:(NSUInteger)steps {
    printf("\033[%luC", steps);
}

- (void)cleanAfter {
    printf("\033[K");
}

- (void)hideCursor {
    printf("\033[?25l");
}

- (void)showCursor {
    printf("\033[?25h");
}

@end
