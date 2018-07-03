//
//  CLIOPath.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/19.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLExplain.h"

@interface CLIOPath : CLExplain

@property (nonatomic, strong, readonly) NSString *key;

@property (nonatomic, assign, readonly) BOOL isRequire;

@property (nonatomic, strong, readonly) NSString *example;

@property (nonatomic, strong, readonly) NSString *explain;

- (instancetype)initWithKey:(NSString *)key require:(BOOL)require;

+ (NSString *)abslutePath:(NSString *)relativePath;

+ (NSString *)currentDirectory;

+ (NSString *)homeDirectory;

@end

@interface CLIOPath (Definer)

@property (nonatomic, readonly) CLIOPath *(^setExplain)(NSString *);

@property (nonatomic, readonly) CLIOPath *(^setExample)(NSString *example);

@end
