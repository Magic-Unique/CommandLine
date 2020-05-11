//
//  NSString+ANSI.h
//  CommandLine
//
//  Created by 吴双 on 2020/5/11.
//

#import <Foundation/Foundation.h>
#import "CLText.h"

#define CCPrint(_style, ...) {CLStringControl*ansi=[CLStringControl.alloc initWithPlainText:@""];ansi=ansi _style;CCPrintf(ansi.style, __VA_ARGS__);}

@interface CLStringControl : NSObject

@property (nonatomic, copy, readonly) NSString *plainText;

@property (nonatomic, copy, readonly) NSString *ansiText;

@property (nonatomic, assign, readonly) CCStyle style;

@property (nonatomic, copy, readonly) void (^print)(void);

- (instancetype)initWithPlainText:(NSString *)plainText;

///< 粗体
@property (readonly) CLStringControl *bold;
///< 细体
@property (readonly) CLStringControl *light;
///< 斜体
@property (readonly) CLStringControl *italic;
///< 下划线
@property (readonly) CLStringControl *underline;
///< 闪烁
@property (readonly) CLStringControl *flash;
///< 反色
@property (readonly) CLStringControl *reversal;
///< 全透明
@property (readonly) CLStringControl *clear;

///< 黑色背景
@property (readonly) CLStringControl *_black;
///< 红色背景
@property (readonly) CLStringControl *_red;
///< 绿色背景
@property (readonly) CLStringControl *_green;
///< 黄色背景
@property (readonly) CLStringControl *_yellow;
///< 蓝色背景
@property (readonly) CLStringControl *_blue;
///< 紫色背景
@property (readonly) CLStringControl *_purple;
///< 深绿背景
@property (readonly) CLStringControl *_darkGreen;
///< 白色背景
@property (readonly) CLStringControl *_white;

///< 黑色字体
@property (readonly) CLStringControl *black;
///< 红色字体
@property (readonly) CLStringControl *red;
///< 绿色字体
@property (readonly) CLStringControl *green;
///< 黄色字体
@property (readonly) CLStringControl *yellow;
///< 蓝色字体
@property (readonly) CLStringControl *blue;
///< 紫色字体
@property (readonly) CLStringControl *purple;
///< 深绿字体
@property (readonly) CLStringControl *darkGreen;
///< 白色字体
@property (readonly) CLStringControl *white;

@end

@interface NSString (ANSI)

@property (nonatomic, strong, readonly) CLStringControl *ansi;

@end
