//
//  CLLoadingIndicator.m
//  CommandLine
//
//  Created by 冷秋 on 2019/12/15.
//

#import "CLLoadingIndicator.h"

static CLLoadingIndicator *CLDefaultIndicator = nil;

@implementation CLLoadingIndicator

+ (instancetype)indicatorWithType:(CLLoadingIndicatorType)type {
    CLLoadingIndicator *indicator = [self new];
    switch (type) {
        case CLLoadingIndicatorTypeBar:
            indicator.frames = @[@"/", @"/", @"-", @"-", @"\\", @"|"];
            indicator.frameDuration = 0.08;
            indicator.position = CLLoadingIndicatorPositionAfterText;
            break;
        case CLLoadingIndicatorTypeSixPoints:
            indicator.frames = @[@"⠇", @"⠏", @"⠋", @"⠙", @"⠹", @"⠸", @"⠼", @"⠴", @"⠦", @"⠧"];
            indicator.frameDuration = 0.07;
            indicator.indicatorStyle = CCStyleForegroundColorDarkGreen;
            break;
        case CLLoadingIndicatorTypeThreePoints:
            indicator.frames = @[@"   ", @".  ", @".. ", @"..."];
            indicator.frameDuration = 1;
            indicator.position = CLLoadingIndicatorPositionAfterText;
            break;
        case CLLoadingIndicatorTypeVolumes:
            indicator.frames = @[@" ", @"▁", @"▂", @"▃", @"▄", @"▅", @"▆", @"▇", @"█"];
            indicator.frameDuration = 0.1;
            indicator.indicatorStyle = CCStyleForegroundColorPurple;
            break;
        case CLLoadingIndicatorTypeCycleVolumes:
            indicator.frames = @[@" ", @"▁", @"▂", @"▃", @"▄", @"▅", @"▆", @"▇", @"█", @"▇", @"▆", @"▅", @"▄", @"▃", @"▂", @"▁"];
            indicator.frameDuration = 0.1;
            indicator.indicatorStyle = CCStyleForegroundColorPurple;
            break;
        case CLLoadingIndicatorTypeClock:
            indicator.frames = @[@"🕛", @"🕐", @"🕑", @"🕒", @"🕓", @"🕔", @"🕕", @"🕖", @"🕗", @"🕘", @"🕙", @"🕚"];
            indicator.frameDuration = 0.10;
            break;
        default:
            break;
    }
    return indicator;
}

+ (instancetype)indicatorWithFrames:(NSArray<NSString *> *)frames {
    CLLoadingIndicator *indicator = [CLLoadingIndicator new];
    indicator.frames = frames;
    return indicator;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frameDuration = 0.3;
        self.indicatorStyle = CCStyleForegroundColorDarkGreen;
        self.position = CLLoadingIndicatorPositionBeforeText;
    }
    return self;
}

- (void)applyDefaultIndicator {
    CLDefaultIndicator = self;
}

+ (instancetype)defaultIndicator {
    if (!CLDefaultIndicator) {
        return [CLLoadingIndicator indicatorWithType:CLLoadingIndicatorTypeSixPoints];
    } else {
        return CLDefaultIndicator;
    }
}

- (NSString *)frameWithText:(NSString *)text index:(NSUInteger)index {
    NSString *prefix = nil;
    NSString *suffix = nil;
    NSString *indicator = CCText(self.indicatorStyle, self.frames[index]);
    text = CCText(self.textStyle, text);
    if (self.position == CLLoadingIndicatorPositionBeforeText) {
        prefix = indicator;
        suffix = text;
    } else {
        prefix = text;
        suffix = indicator;
    }
    return [NSString stringWithFormat:@"%@ %@", prefix, suffix];
}

@end
