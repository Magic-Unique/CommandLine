//
//  CLMultiSelector.m
//  CommandLineDemo
//
//  Created by 冷秋 on 2019/10/20.
//  Copyright © 2019 unique. All rights reserved.
//

#import "CLMultiSelector.h"

@implementation CLMultiSelector

- (instancetype)init {
    self = [super init];
    if (self) {
        self.render = ^NSString *(NSString *item, BOOL highlight, BOOL selected) {
            return [NSString stringWithFormat:@"%@ %@ %@",
                    highlight ? @">" : @" ",
                    selected ? @"[*]" : @"[ ]",
                    item];
        };
    }
    return self;
}

- (NSArray *)select:(NSArray *)list render:(NSString *(^)(id item))render {
    
    unsigned char *marker = malloc(sizeof(unsigned char) * list.count);
    memset(marker, 0, sizeof(unsigned char) * list.count);
    
    NSArray *selection = [self doSelect:^id{
        NSInteger highlight = 0;
        
        while (YES) {
            for (NSUInteger i = 0; i < list.count; i++) {
                BOOL isHighlight = highlight == i;
                BOOL isSelect = marker[i];
                id object = list[i];
                NSString *item = render ? render(object) : [NSString stringWithFormat:@"%@", object];
                NSString *text = self.render(item, isHighlight, isSelect);
                CCStyle style = self.normalStyle;
                if (isHighlight) {
                    style = self.highlightStyle;
                } else if (isSelect) {
                    style = self.selectedStyle;
                }
                CCPrintf(style, @"%@\n", text);
            }
            if (highlight == -1) {
                printf("\033[K");
                CCPrintf(0, @"\n");
                break;
            }
            CLKey input = CLKeyNone;
            while (input == CLKeyNone) {
                input = [self getKey];
                if (input == 'q') {
                    return nil;
                }
                if (input == CLKeyReturn) {
                    break;
                }
                if (input == ' ') {
                    marker[highlight] = !marker[highlight];
                    break;
                }
                if (input != CLKeyUp && input != CLKeyDown) {
                    input = CLKeyNone;
                }
            }
            if (input == CLKeyReturn) {
                highlight = -1;
            }
            printf("\033[%dA", (int)list.count);
            if (input == CLKeyUp) {
                highlight = highlight == 0 ? 0 : highlight - 1;
            } else if (input == CLKeyDown) {
                highlight = (highlight + 1 == list.count) ? highlight : highlight + 1;
            }
        }
        
        NSMutableArray *selection = [NSMutableArray array];
        for (NSUInteger i = 0; i < list.count; i++) {
            if (marker[i]) {
                [selection addObject:list[i]];
            }
        }
        return selection;
    }];
    free(marker);
    if (!selection) {
        exit(1);
    }
    return selection;
}

@end
