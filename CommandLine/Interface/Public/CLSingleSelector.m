//
//  CLSingleSelector.m
//  CommandLineDemo
//
//  Created by 冷秋 on 2019/10/19.
//  Copyright © 2019 unique. All rights reserved.
//

#import "CLSingleSelector.h"
#import "CLSelectItem.h"
#import "CLInputKey.h"

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

- (void)__render:(NSArray<CLSelectItem *> *)list index:(NSUInteger)index highlight:(NSInteger)highlight {
    CLSelectItem *item = list[index];
    NSString *text = self.render(item.title, (highlight == index), item.selected);
    CCStyle style = self.normalStyle;
    if (highlight == index) {
        style = self.highlightStyle;
    } else if (item.selected) {
        style = self.selectedStyle;
    }
    [self cleanAfter];
    CCPrintf(style, @"%@\n", text);
}

- (NSUInteger)select:(NSArray *)list render:(NSString *(^)(id))render {
    
    NSMutableArray<CLSelectItem *> *items = ({
        NSMutableArray<CLSelectItem *> *items = [NSMutableArray array];
        for (id obj in list) {
            NSString *title = render ? render(obj) : [NSString stringWithFormat:@"%@", obj];;
            CLSelectItem *item = [CLSelectItem new];
            item.title = title;
            [items addObject:item];
        }
        [items copy];
    });
    
    NSNumber *selection = [self doSelect:^id{
        
        NSUInteger highlight = 0;
        NSUInteger rerenderLine = 0;
        
        for (NSUInteger i = 0; i < list.count; i++) {
            [self __render:items index:i highlight:highlight];
        }
        
        
        while (YES) {
            NSUInteger step = items.count - rerenderLine;
            [self moveUp:step];
            for (NSUInteger i = rerenderLine; i < rerenderLine + 2 && i < list.count; i++) {
                [self __render:items index:i highlight:highlight];
            }
            step = step - 2;
            [self moveDown:step];
            
            CLInputKey *input = nil;
            while (input == nil) {
                input = [CLInputKey getKey];
                if (input.key == 'q') {
                    break;
                }
                if (input.key == CLKeyReturn) {
                    break;
                }
                if (input.key != CLKeyUp && input.key != CLKeyDown) {
                    input = nil;
                }
            }
            
            
            if (input.key == 'q') {
                return nil;
            }
            else if (input.key == CLKeyReturn) {
                break;
            }
            if (input.key == CLKeyUp) {
                highlight = highlight == 0 ? 0 : highlight - 1;
                rerenderLine = highlight;
            } else if (input.key == CLKeyDown) {
                highlight = (highlight + 1 == list.count) ? highlight : highlight + 1;
                rerenderLine = highlight == 0 ? highlight : highlight - 1;
            }
        }
        //  exit
        [self moveUp:items.count];
        items[highlight].selected = YES;
        for (NSUInteger i = 0; i < list.count; i++) {
            [self cleanAfter];
            printf("\n");
//            [self __render:items index:i highlight:-1];
        }
        
        [self moveUp:items.count];
//        [self cleanAfter];
//        CCPrintf(0, @"\n");
        
        return @(highlight);
    }];
    
    if (!selection) {
        exit(1);
    }
    return selection.unsignedIntegerValue;
}

@end
