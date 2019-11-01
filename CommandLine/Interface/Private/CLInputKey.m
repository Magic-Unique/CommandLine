//
//  CLInputKey.m
//  CommandLine
//
//  Created by 吴双 on 2019/10/30.
//

#import "CLInputKey.h"

@implementation CLInputKey

- (instancetype)initWithKey:(CLKey)key {
    self = [super init];
    if (self) {
        _key = key;
    }
    return self;
}

+ (instancetype)getKey {
    char buf[3];
    ssize_t bytes_read = read(STDIN_FILENO, &buf, 3);
    switch (bytes_read) {
        case -1:
            return nil;
        case 1:
            return [[CLInputKey alloc] initWithKey:buf[0]];
        case 3: {
            switch(buf[2]) {
                case 'A':
                    return [[CLInputKey alloc] initWithKey:CLKeyUp];
                case 'B':
                    return [[CLInputKey alloc] initWithKey:CLKeyDown];
                case 'C':
                    return [[CLInputKey alloc] initWithKey:CLKeyRight];
                case 'D':
                    return [[CLInputKey alloc] initWithKey:CLKeyLeft];
            }
        }
    }
    return nil;
}

@end
