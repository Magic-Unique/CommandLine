//
//  CLLoading.m
//  CommandLine
//
//  Created by 冷秋 on 2019/12/14.
//

#import "CLLoading.h"

@interface CLLoading ()

@property (nonatomic, strong) dispatch_semaphore_t semaphore_t;

@end

@implementation CLLoading

+ (instancetype)loading {
    return [self loadingWithIndicator:[CLLoadingIndicator defaultIndicator]];
}

+ (instancetype)loadingWithIndicator:(CLLoadingIndicator *)indicator {
    CLLoading *loading = [[self alloc] init];
    loading->_indicator = indicator;
    return loading;
}

- (void)start {
    _isLoading = YES;
    NSThread *thread = [[NSThread alloc] initWithTarget:self
                                               selector:@selector(threadLoop)
                                                 object:nil];
    [thread start];
}

- (void)threadLoop {
    [CLCursor hide];
    NSUInteger index = 0;
    while (self.isLoading) {
        NSString *frame = [self frameForIndex:index];
        [CLCursor cleanAfter];
        printf("%s\n", frame.UTF8String);
        [CLCursor up];
        [NSThread sleepForTimeInterval:self.indicator.frameDuration];
        index++;
        if (index >= self.indicator.frames.count) {
            index = 0;
        }
    }
    [CLCursor show];
    if (self.semaphore_t) {
        dispatch_semaphore_signal(self.semaphore_t);
        self.semaphore_t = NULL;
    }
}

- (void)stop {
    _isLoading = NO;
    self.semaphore_t = dispatch_semaphore_create(0);
    dispatch_semaphore_wait(self.semaphore_t, DISPATCH_TIME_FOREVER);
    // wait until the thread exit.
}

- (NSString *)frameForIndex:(NSUInteger)index {
    return [self.indicator frameWithText:self.text index:index];
}

@end
