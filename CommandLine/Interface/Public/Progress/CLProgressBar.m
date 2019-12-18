//
//  CLProgressBar.m
//  CommandLine
//
//  Created by 吴双 on 2019/12/15.
//

#import "CLProgressBar.h"
#import "ANSI.h"

#define clan(c) interface c : CLProgressBar @end @implementation c

static NSUInteger CLHundredFromUnit(double unit) {
    NSUInteger hundred = (NSUInteger)(unit * 100);
    return hundred;
}

@clan(CLProgressPercentBar)

- (NSUInteger)lines {
    return 1;
}

- (NSString *)frameWithText:(NSString *)text progress:(double)progress {
    return [NSString stringWithFormat:@"%@ (%@%%)", text, @(CLHundredFromUnit(progress))];
}

@end

@clan(CLProgressFullBar)

- (NSUInteger)lines {
    return 1;
}

- (NSString *)barWithProgress:(double)progress {
    NSUInteger hundred = CLHundredFromUnit(progress);
    NSMutableString *bar = [NSMutableString string];
    for (NSUInteger i = 0; i < (hundred / 10); i++) {
        [bar appendString:@"█"];
    }
    NSUInteger unit = hundred % 10;
    [bar appendString:@[@"", @" ", @"▎", @"▎", @"▌", @"▌", @"▊", @"▊", @"█", @"█"][unit]];
    while (bar.length < 10) {
        [bar appendString:@" "];
    }
    return CCText(CCStyleForegroundColorGreen|CCStyleBold, bar);
}

- (NSString *)frameWithText:(NSString *)text progress:(double)progress {
    NSString *bar = [self barWithProgress:progress];
    return [NSString stringWithFormat:@"%@ [%@]", text, bar];
}

@end

@implementation CLProgressBar

+ (instancetype)progressBarWithType:(CLProgressBarStyle)style {
    switch (style) {
        case CLProgressBarStyleTextPercent:
            return [CLProgressPercentBar new];
        case CLProgressBarStyleFullBar:
            return [CLProgressFullBar new];
        default:
            break;
    }
    return nil;
}

- (NSString *)frameWithText:(NSString *)text progress:(double)progress {
    return text;
}

@end
