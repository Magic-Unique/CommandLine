//
//  CLDefaultHelpBannerProvider.h
//  Pods
//
//  Created by 冷秋 on 2022/10/24.
//

#import <Foundation/Foundation.h>
#import "CLHelpBannerProvider.h"

typedef NS_ENUM(NSUInteger, CLDefaultHelpBannerSortMethod) {
    CLDefaultHelpBannerSortMethodIndex,
    CLDefaultHelpBannerSortMethodName,
};

@interface CLDefaultHelpBannerProvider : NSObject <CLHelpBannerProvider>

@property (nonatomic, assign) CLDefaultHelpBannerSortMethod sortMethod;

+ (instancetype)sharedProvider;

@end
