//
//  Demo+Loading.m
//  CommandLineDemo
//
//  Created by 吴双 on 2019/12/18.
//  Copyright © 2019 unique. All rights reserved.
//

#import "Demo+Loading.h"

@implementation Demo (Loading)

+ (void)__init_loading {
    CLCommand *loading = [[CLCommand mainCommand] defineSubcommand:@"loading"];
    loading.explain = @"Show loading example";
    loading.setQuery(@"style").setAbbr('s').optional().setExample(@"STYLE").setExplain(@"bar/six-points/three-points/volumes/cycle-volumes/clock");
    [loading handleProcess:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
        NSString *style = process.queries[@"style"];
        CLLoadingIndicatorType type = CLLoadingIndicatorTypeBar;
        if ([style isEqualToString:@"bar"]) {
            type = CLLoadingIndicatorTypeBar;
        }
        else if ([style isEqualToString:@"six-points"]) {
            type = CLLoadingIndicatorTypeSixPoints;
        }
        else if ([style isEqualToString:@"three-points"]) {
            type = CLLoadingIndicatorTypeThreePoints;
        }
        else if ([style isEqualToString:@"volumes"]) {
            type = CLLoadingIndicatorTypeVolumes;
        }
        else if ([style isEqualToString:@"cycle-volumes"]) {
            type = CLLoadingIndicatorTypeCycleVolumes;
        }
        else if ([style isEqualToString:@"clock"]) {
            type = CLLoadingIndicatorTypeClock;
        }
        CLLoading *loading = [CLLoading loadingWithIndicator:[CLLoadingIndicator indicatorWithType:type]];
        loading.text = @"Loading";
        [loading start];
        [NSThread sleepForTimeInterval:5];
        [loading stop];
        return 0;
    }];
    
    CLCommand *progress = [[CLCommand mainCommand] defineSubcommand:@"progress"];
    progress.explain = @"Show progress example";
    progress.setQuery(@"style").setAbbr('s').optional().setExample(@"STYLE").setExplain(@"percent/full-bar");
    [progress handleProcess:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
        NSString *style = process.queries[@"style"];
        CLProgressBarStyle type = CLProgressBarStyleTextPercent;
        if ([style isEqualToString:@"full-bar"]) {
            type = CLProgressBarStyleFullBar;
        }
        CLProgressBar *bar = [CLProgressBar progressBarWithType:type];
        CLProgress *progress = [CLProgress progressWithProgressBar:bar];
        progress.text = @"Loading";
        [progress start];
        for (NSUInteger i = 0; i < 100; i++) {
            progress.progress = i / 100.0;
            [NSThread sleepForTimeInterval:0.05];
        }
        [progress stop];
        return 0;
    }];
}

@end
