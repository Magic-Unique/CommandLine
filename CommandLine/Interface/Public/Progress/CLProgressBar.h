//
//  CLProgressBar.h
//  CommandLine
//
//  Created by 吴双 on 2019/12/15.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CLProgressBarStyle) {
    CLProgressBarStyleTextPercent,
    CLProgressBarStyleFullBar,
};

@interface CLProgressBar : NSObject

@property (nonatomic, assign) NSUInteger lines;

+ (instancetype)progressBarWithType:(CLProgressBarStyle)style;

- (NSString *)frameWithText:(NSString *)text progress:(double)progress;

@end
