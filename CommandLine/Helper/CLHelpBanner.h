//
//  CLHelpBanner.h
//  Pods
//
//  Created by 冷秋 on 2022/10/24.
//

#import <Foundation/Foundation.h>
#import "CLHelpBannerProvider.h"

@interface CLHelpBanner : NSObject

@property (class, nonatomic, strong) id<CLHelpBannerProvider> helpBannerProvider;

+ (NSString *)helpBannerForPrecommands:(NSArray *)precommands commandInfo:(CLCommandInfo *)command error:(NSError *)error;

+ (void)printHelpBannerForPrecommands:(NSArray *)precommands commandInfo:(CLCommandInfo *)command error:(NSError *)error;

@end
