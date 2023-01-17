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

@property (nonatomic, assign) NSUInteger addedIndex;

@end

@implementation CLExplain

- (instancetype)initWithKey:(NSString *)key index:(NSUInteger)index {
    self = [super init];
    if (self) {
        _key = [key copy];
        _addedIndex = index;
    }
    return self;
}

- (NSComparisonResult)sortByKey:(CLExplain *)other {
    return [self.key compare:other.key];
}

- (NSComparisonResult)sortByIndex:(CLExplain *)other {
    if (self.addedIndex < other.addedIndex) {
        return NSOrderedAscending;
    } else if (self.addedIndex > other.addedIndex) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (NSString *)titleWithAbbr:(BOOL)abbr {
    NSAssert(NO, @"Must implemented by subclass");
    return nil;
}

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
