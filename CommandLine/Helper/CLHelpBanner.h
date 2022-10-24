//
//  CLHelpBanner.h
//  Pods
//
//  Created by 吴双 on 2022/10/24.
//

#import <Foundation/Foundation.h>
#import "CLHelpBannerProvider.h"

@interface CLHelpBanner : NSObject

@property (class, nonatomic, strong) id<CLHelpBannerProvider> helpBannerProvider;

- (NSString *)helpBannerForCommand:(CLCommandInfo *)command error:(NSError *)error;

- (void)printHelpBannerForCommand:(CLCommandInfo *)command error:(NSError *)error;

@end
