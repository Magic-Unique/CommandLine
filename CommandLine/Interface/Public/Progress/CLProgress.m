//
//  CLProgress.m
//  CommandLine
//
//  Created by 吴双 on 2019/12/15.
//

#import "CLProgress.h"

@implementation CLProgress

+ (instancetype)progress {
    return [self progressWithProgressBar:nil];
}

+ (instancetype)progressWithProgressBar:(CLProgressBar *)progressBar {
    return [[self alloc] initWithProgressBar:progressBar];
}

- (instancetype)initWithProgressBar:(CLProgressBar *)progressBar {
    self = [super init];
    if (self) {
        _progressBar = progressBar;
    }
    return self;
}

- (void)start {
    [CLCursor hide];
    _isLoading = YES;
    _progress = 0;
    [self print:_progress];
}

- (void)setProgress:(double)progress {
    _progress = progress;
    [self clean];
    [self print:progress];
}

- (void)clean {
    NSUInteger lines = self.progressBar.lines;
    for (NSUInteger i = 0; i < lines; i++) {
        [CLCursor up];
        [CLCursor cleanAfter];
    }
}

- (void)print:(double)progress {
    NSString *frame = [self.progressBar frameWithText:self.text progress:progress];
    printf("%s\n", frame.UTF8String);
}

- (void)stop {
    [CLCursor show];
    _isLoading = NO;
    [self clean];
}

@end
