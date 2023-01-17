//
//  NSString+ANSI.m
//  CommandLine
//
//  Created by 冷秋 on 2020/5/11.
//

#import "NSString+ANSI.h"

@implementation CLStringControl

- (instancetype)initWithPlainText:(NSString *)plainText {
    self = [super init];
    if (self) {
        _plainText = [plainText copy];
    }
    return self;
}

- (NSString *)ansiText {
    if (_plainText == nil) {
        return nil;
    }
    return CCText(_style, _plainText);
}

- (void (^)(void))print {
    return ^{
        CCPrintf(self.style, self.plainText);
    };
}

#define CCANSIStyleImp(name, style) - (CLStringControl *)name { _style |= style; return self; }

CCANSIStyleImp(bold, CCStyleBold);

CCANSIStyleImp(light, CCStyleLight);

CCANSIStyleImp(italic, CCStyleItalic);

CCANSIStyleImp(underline, CCStyleUnderline);

CCANSIStyleImp(flash, CCStyleFlash);

CCANSIStyleImp(reversal, CCStyleReversal);

CCANSIStyleImp(clear, CCStyleClear);




CCANSIStyleImp(_black, CCStyleBackgroundColorBlack);

CCANSIStyleImp(_red, CCStyleBackgroundColorRed);

CCANSIStyleImp(_green, CCStyleBackgroundColorGreen);

CCANSIStyleImp(_yellow, CCStyleBackgroundColorYellow);

CCANSIStyleImp(_blue, CCStyleBackgroundColorBlue);

CCANSIStyleImp(_purple, CCStyleBackgroundColorPurple);

CCANSIStyleImp(_darkGreen, CCStyleBackgroundColorDarkGreen);

CCANSIStyleImp(_white, CCStyleBackgroundColorWhite);




CCANSIStyleImp(black, CCStyleForegroundColorBlack);

CCANSIStyleImp(red, CCStyleForegroundColorDarkRed);

CCANSIStyleImp(green, CCStyleForegroundColorGreen);

CCANSIStyleImp(yellow, CCStyleForegroundColorYellow);

CCANSIStyleImp(blue, CCStyleForegroundColorBlue);

CCANSIStyleImp(purple, CCStyleForegroundColorPurple);

CCANSIStyleImp(darkGreen, CCStyleForegroundColorDarkGreen);

CCANSIStyleImp(white, CCStyleForegroundColorWhite);

#undef CCANSIStyleImp

@end

@implementation NSString (ANSI)

- (CLStringControl *)ansi {
    return [[CLStringControl alloc] initWithPlainText:self];
}

@end
