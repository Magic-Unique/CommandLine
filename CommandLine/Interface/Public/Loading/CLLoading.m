//
//  CLLoading.m
//  CommandLine
//
//  Created by 冷秋 on 2019/12/14.
//

#import "CLLoading.h"

@interface CLLoading ()

@property (nonatomic, strong) dispatch_semaphore_t semaphore_t;

@property (nonatomic, assign) NSUInteger index;

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
    NSThread *thread = [[NSThread alloc] initWithTarget:self
                                               selector:@selector(threadLoop)
                                                 object:nil];
    [thread start];
}

- (void)setText:(NSString *)text {
    _text = text;
    if (self.isLoading) {
        [self __refresh];
    }
}

- (void)threadLoop {
    @synchronized (self) {
        if (self.isLoading) {
            return;
        }
        [CLCursor hide];
        self.index = 0;
        _isLoading = YES;
    }
    while (self.isLoading) {
        [self __refresh];
        [NSThread sleepForTimeInterval:self.indicator.frameDuration];
        @synchronized (self) {
            self.index++;
            if (self.index >= self.indicator.frames.count) {
                self.index = 0;
            }
        }
    }
    @synchronized (self) {
        [CLCursor cleanAfter];
        [CLCursor show];
    }
    if (self.semaphore_t) {
        dispatch_semaphore_signal(self.semaphore_t);
        self.semaphore_t = NULL;
    }
}

- (void)__refresh {
    @synchronized (self) {
        NSString *frame = [self frameForIndex:self.index];
        [CLCursor cleanAfter];
        printf("%s\n", frame.UTF8String);
        [CLCursor up];
    }
}

- (void)stop {
    self.semaphore_t = dispatch_semaphore_create(0);
    _isLoading = NO;
    dispatch_semaphore_wait(self.semaphore_t, DISPATCH_TIME_FOREVER);
    // wait until the thread exit.
}

- (NSString *)frameForIndex:(NSUInteger)index {
    return [self.indicator frameWithText:self.text index:index];
}

@end
