//
//  NSArray+CommandLine.h
//  CommandLine
//
//  Created by Magic-Unique on 2022/10/18.
//

#import <Foundation/Foundation.h>

@interface NSArray<ObjectType> (CommandLine)

- (NSArray *)cl_arrayWithMap:(id(^)(ObjectType item))mapBlock;

@end
