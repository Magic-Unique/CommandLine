//
//  CLLoadingIndicator.h
//  CommandLine
//
//  Created by 冷秋 on 2019/12/15.
//

#import <Foundation/Foundation.h>
#import "ANSI.h"

typedef NS_ENUM(NSUInteger, CLLoadingIndicatorType) {
    CLLoadingIndicatorTypeCustom,
    CLLoadingIndicatorTypeBar,
    CLLoadingIndicatorTypeSixPoints,
    CLLoadingIndicatorTypeThreePoints,
    CLLoadingIndicatorTypeVolumes,
    CLLoadingIndicatorTypeCycleVolumes,
    CLLoadingIndicatorTypeClock,
};

typedef NS_ENUM(NSUInteger, CLLoadingIndicatorPosition) {
    CLLoadingIndicatorPositionBeforeText,
    CLLoadingIndicatorPositionAfterText,
};

@interface CLLoadingIndicator : NSObject

@property (nonatomic, strong) NSArray<NSString *> *frames;

@property (nonatomic, assign) NSTimeInterval frameDuration;

@property (nonatomic, assign) CLLoadingIndicatorPosition position;

@property (nonatomic, assign) CCStyle indicatorStyle;

@property (nonatomic, assign) CCStyle textStyle;

+ (instancetype)indicatorWithType:(CLLoadingIndicatorType)type;

+ (instancetype)indicatorWithFrames:(NSArray<NSString *> *)frames;

- (void)applyDefaultIndicator;

+ (instancetype)defaultIndicator;

- (NSString *)frameWithText:(NSString *)text index:(NSUInteger)index;

@end
