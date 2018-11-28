//
//  CCText.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/26.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CCText.h"

#if DEBUG == 1
#include <sys/sysctl.h>
#endif

NSUInteger CCStyleCodeWithStyle(CCStyle style) {
    switch (style) {
        case CCStyleNone: return 0;
            
        case CCStyleBord: return 1;
        case CCStyleLight: return 2;
        case CCStyleItalic: return 3;
        case CCStyleUnderline: return 4;
        case CCStyleFlash: return 5;
        case CCStyleReversal: return 7;
        case CCStyleClear: return 8;
            
        case CCStyleForegroundColorBlack: return 30;
        case CCStyleForegroundColorDarkRed: return 31;
        case CCStyleForegroundColorGreen: return 32;
        case CCStyleForegroundColorYellow: return 33;
        case CCStyleForegroundColorBlue: return 34;
        case CCStyleForegroundColorPurple: return 35;
        case CCStyleForegroundColorDarkGreen: return 36;
        case CCStyleForegroundColorWhite: return 37;
            
        case CCStyleBackgroundColorBlack: return 40;
        case CCStyleBackgroundColorRed: return 41;
        case CCStyleBackgroundColorGreen: return 42;
        case CCStyleBackgroundColorYellow: return 43;
        case CCStyleBackgroundColorBlue: return 44;
        case CCStyleBackgroundColorPurple: return 45;
        case CCStyleBackgroundColorDarkGreen: return 46;
        case CCStyleBackgroundColorWhite: return 47;
            
        default: return 0;
    }
}

static int CCIsDebuggingInXcode()
{
#if DEBUG == 1
    size_t size = sizeof(struct kinfo_proc);
    struct kinfo_proc info;
    int ret, name[4];
    memset(&info, 0, sizeof(struct kinfo_proc));
    name[0] = CTL_KERN;
    name[1] = KERN_PROC;
    name[2] = KERN_PROC_PID;
    name[3] = getpid();
    if ((ret = (sysctl(name, 4, &info, &size, NULL, 0)))) {
        return ret; /* sysctl() failed for some reason */
    }
    return (info.kp_proc.p_flag & P_TRACED) ? 1 : 0;
#else
    return 0;
#endif
}

NSString *CCStyleStringWithStyle(CCStyle style) {
#ifdef CCTEXT_COLORFUL_OFF
    return @"";
#else
    if (style) {
        NSMutableArray *codes = [NSMutableArray array];
        for (NSUInteger i = 0; i < 32; i++) {
            CCStyle item = 1 << i;
            if ((style & item) == item) {
                NSUInteger code = CCStyleCodeWithStyle(item);
                if (code > 0) {
                    [codes addObject:@(code).stringValue];
                }
            }
        }
        if (codes.count) {
            return [NSString stringWithFormat:@"\033[%@m", [codes componentsJoinedByString:@";"]];
        }
    }
    return @"\033[0m";
#endif
}

void CCPrintf(CCStyle style, NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    if (style == CCStyleNone || CCIsDebuggingInXcode()) {
        printf("%s", str.UTF8String);
    } else {
        printf("%s", CCStyleStringWithStyle(style).UTF8String);
        printf("%s", str.UTF8String);
        printf("%s", CCStyleStringWithStyle(CCStyleNone).UTF8String);
    }
}

NSString *CCText(CCStyle style, NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    if (style == CCStyleNone || CCIsDebuggingInXcode()) {
        return str;
    } else {
        NSMutableString *output = [NSMutableString string];
        [output appendString:CCStyleStringWithStyle(style)];
        [output appendString:str];
        [output appendString:CCStyleStringWithStyle(CCStyleNone)];
        return [output copy];
    }
}

