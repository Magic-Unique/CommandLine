//
//  CLCursor.m
//  CommandLine
//
//  Created by 冷秋 on 2019/12/14.
//

#import "CLCursor.h"

@implementation CLCursor

+ (void)doEsc:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    printf("\033[%s", str.UTF8String);
}

+ (void)up { [self up:1]; }
+ (void)up:(NSUInteger)steps { [self doEsc:@"%luA", steps]; }

+ (void)down { [self down:1]; }
+ (void)down:(NSUInteger)steps { [self doEsc:@"%luB", steps]; }

+ (void)left { [self left:1]; }
+ (void)left:(NSUInteger)steps { [self doEsc:@"%luD", steps]; }

+ (void)right { [self right:1]; }
+ (void)right:(NSUInteger)steps { [self doEsc:@"%luC", steps]; }

+ (void)cleanAfter { [self doEsc:@"K"]; }

+ (void)hide { [self doEsc:@"?25l"]; }

+ (void)show { [self doEsc:@"?25h"]; }

+ (void)storagePosition { [self doEsc:@"s"]; }

+ (void)recoverPosition { [self doEsc:@"u"]; }

+ (void)clear {
    [self doEsc:@"2J"];
}

@end
