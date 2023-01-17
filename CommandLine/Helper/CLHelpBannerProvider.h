//
//  CLHelpBannerProvider.h
//  Pods
//
//  Created by 冷秋 on 2022/10/24.
//

#ifndef CLHelpBannerProvider_h
#define CLHelpBannerProvider_h

@class CLCommandInfo;

@protocol CLHelpBannerProvider <NSObject>

- (NSString *)helpBannerForPrecommands:(NSArray *)precommands commandInfo:(CLCommandInfo *)commandInfo error:(NSError *)error;

@end

#endif /* CLHelpBannerProvider_h */
