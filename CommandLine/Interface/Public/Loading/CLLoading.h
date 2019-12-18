//
//  CLLoading.h
//  CommandLine
//
//  Created by 冷秋 on 2019/12/14.
//

#import "CLInterface.h"
#import "CLLoadingIndicator.h"

@interface CLLoading : CLInterface

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong, readonly) CLLoadingIndicator *indicator;

@property (nonatomic, assign, readonly) BOOL isLoading;

+ (instancetype)loading;
+ (instancetype)loadingWithIndicator:(CLLoadingIndicator *)indicator;

- (void)start;
- (void)stop;

@end
