//
//  CLIO.m
//  CommandLine
//
//  Created by Magic-Unique on 2019/4/28.
//

#import "CLIO.h"
#import <CommandLine/ANSI.h>
#import "CLProcess.h"
#import "CLFlag.h"

#define CLProcessFlag(_flag) ([CLProcess.currentProcess flag:[CLFlag _flag].key])

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

void CLANSIPrintf(CCStyle style, NSString * _Nonnull format, ...) {
    if (CLProcessFlag(silent)) {
        return;
    }
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    if (CLProcessFlag(noANSI)) {
        style = CCStyleNone;
    }
    CCPrintf(style, @"%@", str);
}

static NSString *INDENT = nil;
static NSUInteger INDENT_LENGTH = 0;

void CLSetIndent(NSString * _Nullable indent) {
    INDENT = indent;
}

void CLPushIndent(void) {
    INDENT_LENGTH++;
}

void CLPopIndent(void) {
    INDENT_LENGTH == 0 ? 0 : INDENT_LENGTH--;
}

NSString *_CLGetCurrentIndent(void) {
    NSMutableString *indent = [NSMutableString string];
    for (NSUInteger i = 0; i < INDENT_LENGTH; i++) {
        [indent appendString:INDENT?:@"    "];
    }
    return [indent copy];
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
        CCStyle style = CCStyleLight;
        if (CLProcessFlag(noANSI)) {
            style = CCStyleNone;
        }
        CCPrintf(style, @"%@%@\n", _CLGetCurrentIndent(), str);
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
    CCStyle style = CCStyleNone;
    if (CLProcessFlag(noANSI)) {
        style = CCStyleNone;
    }
    CCPrintf(style, @"%@%@\n", _CLGetCurrentIndent(), str);
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
    CCPrintf(style, @"%@%@\n", _CLGetCurrentIndent(), str);
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
    CCPrintf(style, @"%@%@\n", _CLGetCurrentIndent(), str);
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
    CCPrintf(style, @"%@%@\n", _CLGetCurrentIndent(), str);
}

void CLLog(NSString * _Nonnull format, ...) {
#if DEBUG == 1
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    CCPrintf(CCStyleNone, @"%@%@\n", _CLGetCurrentIndent(), str);
#endif
}

