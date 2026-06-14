//
//  NSArray+CommandLine.h
//  CommandLine
//
//  Created by Magic-Unique on 2026/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (CommandLine)

@end

@interface NSMutableArray<ObjectType> (CommandLine)

- (NSMutableArray *)cl_takeWithFilter:(BOOL (^)(ObjectType obj))block;

@end

NS_ASSUME_NONNULL_END
