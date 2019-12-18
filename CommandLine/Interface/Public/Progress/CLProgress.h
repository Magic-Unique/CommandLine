//
//  CLProgress.h
//  CommandLine
//
//  Created by 吴双 on 2019/12/15.
//

#import "CLInterface.h"
#import "CLProgressBar.h"

@interface CLProgress : CLInterface

@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) double progress;

@property (nonatomic, assign, readonly) BOOL isLoading;

@property (nonatomic, strong, readonly) CLProgressBar *progressBar;

+ (instancetype)progress;
+ (instancetype)progressWithProgressBar:(CLProgressBar *)progressBar;

- (void)start;
- (void)stop;

@end
