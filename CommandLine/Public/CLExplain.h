//
//  CLExplain.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/20.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLExplain : NSObject

@property (nonatomic, strong, readonly, nullable) NSString *title;

@property (nonatomic, strong, readonly, nullable) NSString *subtitle;

@property (nonatomic, assign, readonly) BOOL isInheritable;

@end




@interface CLExplain (Definer)

@property (nonatomic, readonly, nonnull) CLExplain * _Nonnull (^inheritify)(void);

@end

