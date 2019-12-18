//
//  CLMultiSelector.m
//  CommandLineDemo
//
//  Created by 冷秋 on 2019/10/20.
//  Copyright © 2019 unique. All rights reserved.
//

#import "CLMultiSelector.h"
#import "CLSelectItem.h"
#import "CLInputKey.h"
#import "Launch.h"

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

- (void)__render:(NSArray<CLSelectItem *> *)list index:(NSUInteger)index highlight:(NSInteger)highlight {
    CLSelectItem *item = list[index];
    NSString *text = self.render(item.title, (highlight == index), item.selected);
    CCStyle style = self.normalStyle;
    if (highlight == index) {
        style = self.highlightStyle;
    } else if (item.selected) {
        style = self.selectedStyle;
    }
    [CLCursor cleanAfter];
    CCPrintf(style, @"%@\n", text);
}

- (NSArray *)select:(NSArray *)list render:(NSString *(^)(id item))render {
    
    NSArray<CLSelectItem *> *items = ({
        NSMutableArray<CLSelectItem *> *items = [NSMutableArray array];
        for (id obj in list) {
            NSString *title = render ? render(obj) : [NSString stringWithFormat:@"%@", obj];;
            CLSelectItem *item = [CLSelectItem new];
            item.title = title;
            [items addObject:item];
        }
        [items copy];
    });
    
    NSArray *selection = [self doSelect:^id{
        
        NSUInteger highlight = 0;
        
        while (YES) {
            for (NSUInteger i = 0; i < items.count; i++) {
                [self __render:items index:i highlight:highlight];
            }
            
            CLInputKey *input = [CLInputKey getSelectorKey:YES];
            
            if (input.key == 'q') {
                return nil;
            }
            else if (input.key == CLKeyReturn) {
                break;
            }
            else if (input.key == ' ') {
                CLSelectItem *item = items[highlight];
                item.selected = !item.selected;
            }
            else if (input.key == CLKeyUp) {
                highlight = highlight == 0 ? 0 : highlight - 1;
            } else if (input.key == CLKeyDown) {
                highlight = (highlight + 1 == list.count) ? highlight : highlight + 1;
            }
            [CLCursor up:items.count];
        }
        //  exit
        [CLCursor up:items.count];
        for (NSUInteger i = 0; i < list.count; i++) {
            [CLCursor cleanAfter];
            CCPrintf(0, @"\n");
        }
        
        [CLCursor up:items.count];
//        [self cleanAfter];
//        CCPrintf(0, @"\n");
        
        NSMutableArray *selection = [NSMutableArray array];
        for (NSUInteger i = 0; i < list.count; i++) {
            CLSelectItem *item = items[i];
            if (item.selected) {
                [selection addObject:list[i]];
            }
        }
        return selection;
    }];
    
    if (!selection) {
        exit(1);
    }
    return selection;
}

@end
