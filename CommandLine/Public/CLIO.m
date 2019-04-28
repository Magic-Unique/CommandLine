//
//  CLIO.m
//  CommandLine
//
//  Created by 吴双 on 2019/4/28.
//

#import "CLIO.h"
#import "CCText.h"
#import "CLProcess.h"

FOUNDATION_EXTERN void CLVerbose(NSString * _Nonnull format, ...) {
    if ([CLProcess.sharedProcess flag:@"verbose"]) {
        va_list args;
        va_start(args, format);
        NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
        str = [str stringByAppendingString:@"\n"];
        va_end(args);
        printf("%s", str.UTF8String);
    }
}

FOUNDATION_EXTERN void CLInfo(NSString * _Nonnull format, ...) {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    str = [str stringByAppendingString:@"\n"];
    va_end(args);
    CCPrintf(CCStyleLight, str);
}

FOUNDATION_EXTERN void CLSuccess(NSString * _Nonnull format, ...) {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    str = [str stringByAppendingString:@"\n"];
    va_end(args);
    CCPrintf(CCStyleForegroundColorGreen, str);
    
}

FOUNDATION_EXTERN void CLWarning(NSString * _Nonnull format, ...) {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    str = [str stringByAppendingString:@"\n"];
    va_end(args);
    CCPrintf(CCStyleForegroundColorYellow, str);
}

FOUNDATION_EXTERN void CLError(NSString * _Nonnull format, ...) {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    str = [str stringByAppendingString:@"\n"];
    va_end(args);
    CCPrintf(CCStyleForegroundColorDarkRed, str);
}

void CLLog(NSString * _Nonnull format, ...) {
#if DEBUG == 1
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    str = [str stringByAppendingString:@"\n"];
    va_end(args);
    CCPrintf(0, str);
#endif
}

