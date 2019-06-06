//
//  CCText.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/26.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLText.h"
#import <CommandLine/Tools.h>

NSUInteger CCStyleCodeWithStyle(CCStyle style) {
    switch (style) {
#define CaseStyle(code, style) case style: return code;
            CaseStyle(0, CCStyleNone);
            
            CaseStyle(1, CCStyleBold);
            CaseStyle(2, CCStyleLight);
            CaseStyle(3, CCStyleItalic);
            CaseStyle(4, CCStyleUnderline);
            CaseStyle(5, CCStyleFlash);
            CaseStyle(7, CCStyleReversal);
            CaseStyle(8, CCStyleClear);
            
            CaseStyle(30, CCStyleForegroundColorBlack);
            CaseStyle(31, CCStyleForegroundColorDarkRed);
            CaseStyle(32, CCStyleForegroundColorGreen);
            CaseStyle(33, CCStyleForegroundColorYellow);
            CaseStyle(34, CCStyleForegroundColorBlue);
            CaseStyle(35, CCStyleForegroundColorPurple);
            CaseStyle(36, CCStyleForegroundColorDarkGreen);
            CaseStyle(37, CCStyleForegroundColorWhite);
            
            CaseStyle(40, CCStyleBackgroundColorBlack);
            CaseStyle(41, CCStyleBackgroundColorRed);
            CaseStyle(42, CCStyleBackgroundColorGreen);
            CaseStyle(43, CCStyleBackgroundColorYellow);
            CaseStyle(44, CCStyleBackgroundColorBlue);
            CaseStyle(45, CCStyleBackgroundColorPurple);
            CaseStyle(46, CCStyleBackgroundColorDarkGreen);
            CaseStyle(47, CCStyleBackgroundColorWhite);
#undef CaseStyle
            
        default: return 0;
    }
}

NSUInteger CCStyleWithStyleCode(NSUInteger code) {
    switch (code) {
#define CaseStyle(code, style) case code: return style;
            CaseStyle(0, CCStyleNone);
            
            CaseStyle(1, CCStyleBold);
            CaseStyle(2, CCStyleLight);
            CaseStyle(3, CCStyleItalic);
            CaseStyle(4, CCStyleUnderline);
            CaseStyle(5, CCStyleFlash);
            CaseStyle(7, CCStyleReversal);
            CaseStyle(8, CCStyleClear);
            
            CaseStyle(30, CCStyleForegroundColorBlack);
            CaseStyle(31, CCStyleForegroundColorDarkRed);
            CaseStyle(32, CCStyleForegroundColorGreen);
            CaseStyle(33, CCStyleForegroundColorYellow);
            CaseStyle(34, CCStyleForegroundColorBlue);
            CaseStyle(35, CCStyleForegroundColorPurple);
            CaseStyle(36, CCStyleForegroundColorDarkGreen);
            CaseStyle(37, CCStyleForegroundColorWhite);
            
            CaseStyle(40, CCStyleBackgroundColorBlack);
            CaseStyle(41, CCStyleBackgroundColorRed);
            CaseStyle(42, CCStyleBackgroundColorGreen);
            CaseStyle(43, CCStyleBackgroundColorYellow);
            CaseStyle(44, CCStyleBackgroundColorBlue);
            CaseStyle(45, CCStyleBackgroundColorPurple);
            CaseStyle(46, CCStyleBackgroundColorDarkGreen);
            CaseStyle(47, CCStyleBackgroundColorWhite);
#undef CaseStyle
            
        default: return 0;
    }
}

NSString *CCStyleStringWithStyle(CCStyle style) {
    if (CLProcessIsAttached()) {
        return @"";
    }
    if (style != CCStyleNone) {
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
}

void CCPrintf(CCStyle style, NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    if (style == CCStyleNone || CLProcessIsAttached()) {
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
    
    if (style == CCStyleNone || CLProcessIsAttached()) {
        return str;
    } else {
        NSMutableString *output = [NSMutableString string];
        [output appendString:CCStyleStringWithStyle(style)];
        [output appendString:str];
        [output appendString:CCStyleStringWithStyle(CCStyleNone)];
        return [output copy];
    }
}

