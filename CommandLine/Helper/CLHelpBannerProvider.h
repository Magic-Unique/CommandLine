//
//  CLHelpBannerProvider.h
//  Pods
//
//  Created by 吴双 on 2022/10/24.
//

#ifndef CLHelpBannerProvider_h
#define CLHelpBannerProvider_h

@class CLCommandInfo;

@protocol CLHelpBannerProvider <NSObject>

- (NSString *)helpBannerForCommandInfo:(CLCommandInfo *)commandInfo error:(NSError *)error;

@end

#endif /* CLHelpBannerProvider_h */
