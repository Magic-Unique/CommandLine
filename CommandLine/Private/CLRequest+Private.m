//
//  CLRequest+Private.m
//  CommandLine
//
//  Created by 吴双 on 2019/4/13.
//

#import "CLRequest+Private.h"

@implementation CLRequest (Stack)

static BOOL _verbose = NO;

+ (BOOL)verbose {
    return _verbose;
}

+ (void)setVerbose:(BOOL)verbose {
    _verbose = verbose;
}

@end
