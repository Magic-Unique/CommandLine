//
//  CLIOPath.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/19.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLExplain.h"

@interface CLIOPath : CLExplain

@property (nonatomic, strong, readonly, nonnull) NSString *title;

@property (nonatomic, assign, readonly) BOOL isRequire;

@property (nonatomic, strong, readonly, nullable) NSString *example;

@property (nonatomic, strong, readonly, nullable) NSString *explain;

- (instancetype _Nonnull)initWithKey:(NSString * _Nonnull)key index:(NSUInteger)index require:(BOOL)require;

+ (NSString * _Nonnull)abslutePath:(NSString * _Nonnull)relativePath;

+ (NSString * _Nonnull)currentDirectory;

+ (NSString * _Nonnull)homeDirectory;

@end

@interface CLIOPath (Definer)

/**
 Set description
 */
@property (nonatomic, readonly, nonnull) CLIOPath * _Nonnull (^setExplain)(NSString * _Nonnull explain);

/**
 Set example, Such as: /path/to/your_file
 
 Example will be printed in help document.
 */
@property (nonatomic, readonly, nonnull) CLIOPath * _Nonnull (^setExample)(NSString * _Nonnull example);

/**
 Inherit to subcommand
 */
@property (nonatomic, readonly, nonnull) CLIOPath * _Nonnull (^inheritify)(void);

@end
