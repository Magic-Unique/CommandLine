//
//  CLSingleSelector.m
//  CommandLineDemo
//
//  Created by 冷秋 on 2019/10/19.
//  Copyright © 2019 unique. All rights reserved.
//

#import "CLSingleSelector.h"

@implementation CLSingleSelector

- (instancetype)init {
    self = [super init];
    if (self) {
        self.render = ^NSString *(NSString *item, BOOL highlight, BOOL selected) {
            return [NSString stringWithFormat:@"%@%@", highlight ? @"> " : @"  ", item];
        };
    }
    return self;
}

- (NSUInteger)select:(NSArray *)list render:(NSString *(^)(id))render {
    NSNumber *selection = [self doSelect:^id{
        NSInteger highlight = 0;
        NSInteger selection = -1;
        
        while (YES) {
            for (NSUInteger i = 0; i < list.count; i++) {
                BOOL isHighlight = highlight == i;
                BOOL isSelect = selection == i;
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
                if (input != CLKeyUp && input != CLKeyDown) {
                    input = CLKeyNone;
                }
            }
            if (input == CLKeyReturn) {
                selection = highlight;
                highlight = -1;
            }
            printf("\033[%dA", (int)list.count);
            if (input == CLKeyUp) {
                highlight = highlight == 0 ? 0 : highlight - 1;
            } else if (input == CLKeyDown) {
                highlight = (highlight + 1 == list.count) ? highlight : highlight + 1;
            }
        }
        
        return @(selection);
    }];
    if (!selection) {
        exit(1);
    }
    return selection.unsignedIntegerValue;
}

@end
