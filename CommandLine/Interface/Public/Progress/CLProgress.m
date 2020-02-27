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
    [self __refresh];
}

- (void)stop {
    _isLoading = NO;
    [self clean];
    [CLCursor show];
}

- (void)setProgress:(double)progress {
    _progress = progress;
    if (_isLoading) {
        [self __refresh];
    }
}

- (void)setText:(NSString *)text {
    _text = text;
    if (self.isLoading) {
        [self print:self.progress];
    }
}

- (void)__refresh {
    [self clean];
    [self print:_progress];
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

@end
