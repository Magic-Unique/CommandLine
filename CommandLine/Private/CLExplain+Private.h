//
//  CLExplain+Private.h
//  CommandLine
//
//  Created by Magic-Unique on 2018/11/28.
//

#import "CLExplain.h"

@protocol CLExplainDelegate <NSObject>

@optional
- (void)explainDidInheritify:(CLExplain *)explain;

@end

@interface CLExplain (Private)

@property (nonatomic, weak) id<CLExplainDelegate> delegate;

@end
