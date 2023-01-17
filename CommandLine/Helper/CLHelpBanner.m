//
//  CLHelpBanner.m
//  Pods
//
//  Created by 冷秋 on 2022/10/24.
//

#import "CLHelpBanner.h"
#import "CLDefaultHelpBannerProvider.h"

static id<CLHelpBannerProvider> provider = nil;

@implementation CLHelpBanner

+ (void)setHelpBannerProvider:(id<CLHelpBannerProvider>)helpBannerProvider {
    provider = helpBannerProvider;
}

+ (id<CLHelpBannerProvider>)helpBannerProvider {
    if (!provider) {
        provider = [[CLDefaultHelpBannerProvider alloc] init];
    }
    return provider;
}

+ (NSString *)helpBannerForPrecommands:(NSArray *)precommands commandInfo:(CLCommandInfo *)command error:(NSError *)error {
    return [[self helpBannerProvider] helpBannerForPrecommands:precommands commandInfo:command error:error];
}

+ (void)printHelpBannerForPrecommands:(NSArray *)precommands commandInfo:(CLCommandInfo *)command error:(NSError *)error {
    NSString *banner = [self helpBannerForPrecommands:precommands commandInfo:command error:error];
    if (banner) {
        printf("%s", banner.UTF8String);
    }
}

@end
