//
//  CLDemo.m
//  CommandLineDemo
//
//  Created by 冷秋 on 2019/10/18.
//  Copyright © 2019 unique. All rights reserved.
//

#import "CLDemo.h"
#include <stdio.h>
#include <stdlib.h>
#include <ncurses.h>
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

@implementation CLDemo

+ (void)__changeKeyboardMode:(void (^)(void))block {
    struct termios oldt;
    getattr(&oldt);
    setattr(oldt);
    block();
    resetattr(&oldt);
}

+ (NSUInteger)select:(NSArray *)list
        defaultIndex:(NSUInteger)defaultIndex
              normal:(CCStyle)normal
           highlight:(CCStyle)highlight
              render:(NSString *(^)(id item, NSUInteger index, BOOL highlight))render {
    
    NSInteger index = defaultIndex;
    NSUInteger selection = 0;
    
    struct termios oldt;
    getattr(&oldt);
    setattr(oldt);
    
    while (YES) {
        for (NSUInteger i = 0; i < list.count; i++) {
            if (i == index) {
                CCPrintf(highlight, @"> %@\n", render(list[i], i, YES));
            } else {
                CCPrintf(normal, @"  %@\n", render(list[i], i, NO));
            }
        }
        if (index == -1) {
            printf("\033[K");
            CCPrintf(0, @"\n");
            break;
        }
        CCPrintf(CCStyleNone, @"Press up and down to choose one, q to quit, return to confirm.\n");
        CLKey input = CLKeyNone;
        while (input == CLKeyNone) {
            input = getkey();
            if (input == 'q') {
                resetattr(&oldt);
                exit(0);
            }
            if (input == CLKeyReturn) {
                break;
            }
            if (input != CLKeyUp && input != CLKeyDown) {
                input = CLKeyNone;
            }
        }
        if (input == CLKeyReturn) {
            selection = index;
            index = -1;
        }
        printf("\033[%dA", (int)list.count + 1);
        if (input == CLKeyUp) {
            index = index == 0 ? 0 : index - 1;
        } else if (input == CLKeyDown) {
            index = (index + 1 == list.count) ? index : index + 1;
        }
    }
    
    resetattr(&oldt);
    
    return selection;
}

+ (NSArray *)multiSelect:(NSArray *)list normal:(CCStyle)normal highlight:(CCStyle)highlight selected:(CCStyle)selected render:(NSString *(^)(id, NSUInteger, BOOL, BOOL))render {
    
    NSMutableArray *selectStatus = [NSMutableArray array];
    for (NSUInteger i = 0; i < list.count; i++) {
        selectStatus[i] = @NO;
    }
    
    NSInteger index = 0;
    
    struct termios oldt;
    getattr(&oldt);
    setattr(oldt);
    
    while (YES) {
        for (NSUInteger i = 0; i < list.count; i++) {
            NSNumber *item = selectStatus[i];
            BOOL highlightion = i == index;
            BOOL selection = item.boolValue;
            
            CCStyle style = CCStyleNone;
            
            if (highlightion) {
                style = highlight;
            }
            else if (selection) {
                style = selected;
            }
            else {
                style = normal;
            }
            CCPrintf(style, @"%@\n", render(list[i], i, highlightion, selection));
        }
        if (index == -1) {
            printf("\033[K");
            CCPrintf(0, @"\n");
            break;
        }
        CCPrintf(CCStyleNone, @"Press up and down to choose one, q to quit, space to select current, a to select all, A to unselect all, r to reselect, return to confirm.\n");
        CLKey input = CLKeyNone;
        while (input == CLKeyNone) {
            input = getkey();
            if (input == 'q') {
                resetattr(&oldt);
                exit(0);
            }
            else if (input == CLKeyReturn) {
            }
            else if (input == ' ') {
                BOOL status = [selectStatus[index] boolValue];
                selectStatus[index] = @(!status);
            }
            else if (input == 'a') {
                for (NSUInteger i = 0; i < selectStatus.count; i++) {
                    selectStatus[i] = @YES;
                }
            }
            else if (input == 'A') {
                for (NSUInteger i = 0; i < selectStatus.count; i++) {
                    selectStatus[i] = @NO;
                }
            }
            else if (input == 'r') {
                for (NSUInteger i = 0; i < selectStatus.count; i++) {
                    NSNumber *status = selectStatus[i];
                    selectStatus[i] = @(!status.boolValue);
                }
            }
            else if (input != CLKeyUp && input != CLKeyDown) {
                input = CLKeyNone;
            }
        }
        if (input == CLKeyReturn) {
            index = -1;
        }
        printf("\033[%dA", (int)list.count + 1);
        if (input == CLKeyUp) {
            index = index == 0 ? 0 : index - 1;
        } else if (input == CLKeyDown) {
            index = (index + 1 == list.count) ? index : index + 1;
        }
    }
    
    resetattr(&oldt);
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger i = 0; i < list.count; i++) {
        NSNumber *status = selectStatus[i];
        if (status.boolValue) {
            [result addObject:list[i]];
        }
    }
    
    return [result copy];
}

@end
