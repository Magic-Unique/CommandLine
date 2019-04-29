//
//  CLIO.m
//  CommandLine
//
//  Created by Magic-Unique on 2019/4/28.
//

#import "CLIO.h"
#import "CCText.h"
#import "CLProcess.h"
#import "CLFlag.h"

#define CLProcessFlag(_flag) ([CLProcess.sharedProcess flag:[CLFlag _flag].key])

void CLPrintf(NSString * _Nonnull format, ...) {
    if (CLProcessFlag(silent)) {
        return;
    }
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    CCStyle style = CCStyleNone;
    if (CLProcessFlag(noANSI)) {
        style = CCStyleNone;
    }
    CCPrintf(style, @"%@", str);
}

void CLVerbose(NSString * _Nonnull format, ...) {
    if (CLProcessFlag(silent)) {
        return;
    }
    if (CLProcessFlag(verbose)) {
        va_list args;
        va_start(args, format);
        NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        CCStyle style = CCStyleNone;
        if (CLProcessFlag(noANSI)) {
            style = CCStyleNone;
        }
        CCPrintf(style, @"%@\n", str);
    }
}

void CLInfo(NSString * _Nonnull format, ...) {
    if (CLProcessFlag(silent)) {
        return;
    }
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    CCStyle style = CCStyleLight;
    if (CLProcessFlag(noANSI)) {
        style = CCStyleNone;
    }
    CCPrintf(style, @"%@\n", str);
}

void CLSuccess(NSString * _Nonnull format, ...) {
    if (CLProcessFlag(silent)) {
        return;
    }
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    CCStyle style = CCStyleForegroundColorGreen;
    if (CLProcessFlag(noANSI)) {
        style = CCStyleNone;
    }
    CCPrintf(style, @"%@\n", str);
}

void CLWarning(NSString * _Nonnull format, ...) {
    if (CLProcessFlag(silent)) {
        return;
    }
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    CCStyle style = CCStyleForegroundColorYellow;
    if (CLProcessFlag(noANSI)) {
        style = CCStyleNone;
    }
    CCPrintf(style, @"%@\n", str);
}

void CLError(NSString * _Nonnull format, ...) {
    if (CLProcessFlag(silent)) {
        return;
    }
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    CCStyle style = CCStyleForegroundColorDarkRed;
    if (CLProcessFlag(noANSI)) {
        style = CCStyleNone;
    }
    CCPrintf(style, @"%@\n", str);
}

void CLLog(NSString * _Nonnull format, ...) {
#if DEBUG == 1
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    CCPrintf(0, @"%@\n", str);
#endif
}

