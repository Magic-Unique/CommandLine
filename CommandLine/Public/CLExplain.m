//
//  CLExplain.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/20.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLExplain.h"
#import "CLExplain+Private.h"

@interface CLExplain ()

@property (nonatomic, weak) id<CLExplainDelegate> delegate;

@end

@implementation CLExplain

@end

@implementation CLExplain (Definer)

- (CLExplain *(^)(void))inheritify {
    return ^CLExplain *(void) {
        self->_isInheritable = YES;
        if ([self.delegate respondsToSelector:@selector(explainDidInheritify:)]) {
            [self.delegate explainDidInheritify:self];
        }
        return self;
    };
}

@end
