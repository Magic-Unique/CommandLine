//
//  CLIOPath.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/19.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLExplain.h"

@interface CLIOPath : CLExplain

@property (nonatomic, strong, readonly, nonnull) NSString *key;

@property (nonatomic, assign, readonly) BOOL isRequire;

@property (nonatomic, strong, readonly, nullable) NSString *example;

@property (nonatomic, strong, readonly, nullable) NSString *explain;

- (instancetype _Nonnull)initWithKey:(NSString * _Nonnull)key require:(BOOL)require;

+ (NSString * _Nonnull)abslutePath:(NSString * _Nonnull)relativePath;

+ (NSString * _Nonnull)currentDirectory;

+ (NSString * _Nonnull)homeDirectory;

@end

@interface CLIOPath (Definer)

@property (nonatomic, readonly, nonnull) CLIOPath * _Nonnull (^setExplain)(NSString * _Nonnull explain);

@property (nonatomic, readonly, nonnull) CLIOPath * _Nonnull (^setExample)(NSString * _Nonnull example);

@property (nonatomic, readonly, nonnull) CLIOPath * _Nonnull (^inheritify)(void);

@end
