//
//  CLInterface.h
//  CommandLineDemo
//
//  Created by 冷秋 on 2019/10/19.
//  Copyright © 2019 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLInterface : NSObject

- (void)moveUp:(NSUInteger)steps;

- (void)moveDown:(NSUInteger)steps;

- (void)moveLeft:(NSUInteger)steps;

- (void)moveRight:(NSUInteger)steps;

- (void)cleanAfter;

- (void)hideCursor;

- (void)showCursor;

- (void)storageCursorPosition;

- (void)recoverCursorPosition;

@end
