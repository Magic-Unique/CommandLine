//
//  CCText.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/26.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, CCStyle) {
    ///< 无样式
    CCStyleNone = 0,
    
    ///< 粗体
    CCStyleBord = 1 << 0,
    ///< 细体
    CCStyleLight = 1 << 1,
    ///< 斜体
    CCStyleItalic = 1 << 2,
    ///< 下划线
    CCStyleUnderline = 1 << 3,
    ///< 闪烁
    CCStyleFlash = 1 << 4,
    ///< 反色
    CCStyleReversal = 1 << 5,
    ///< 全透明
    CCStyleClear = 1 << 6,
    
    ///< 黑色背景
    CCStyleBackgroundColorBlack = 1 << 8,
    ///< 红色背景
    CCStyleBackgroundColorRed = 1 << 9,
    ///< 绿色背景
    CCStyleBackgroundColorGreen = 1 << 10,
    ///< 黄色背景
    CCStyleBackgroundColorYellow = 1 << 11,
    ///< 蓝色背景
    CCStyleBackgroundColorBlue = 1 << 12,
    ///< 紫色背景
    CCStyleBackgroundColorPurple = 1 << 13,
    ///< 深绿背景
    CCStyleBackgroundColorDarkGreen = 1 << 14,
    ///< 白色背景
    CCStyleBackgroundColorWhite = 1 << 15,
    
    ///< 黑色字体
    CCStyleForegroundColorBlack = 1 << 16,
    ///< 红色字体
    CCStyleForegroundColorDarkRed = 1 << 17,
    ///< 绿色字体
    CCStyleForegroundColorGreen = 1 << 18,
    ///< 黄色字体
    CCStyleForegroundColorYellow = 1 << 19,
    ///< 蓝色字体
    CCStyleForegroundColorBlue = 1 << 20,
    ///< 紫色字体
    CCStyleForegroundColorPurple = 1 << 21,
    ///< 深绿字体
    CCStyleForegroundColorDarkGreen = 1 << 22,
    ///< 白色字体
    CCStyleForegroundColorWhite = 1 << 23,
};


/**
 Print a colorful text to stdout.

 @param style CCStyleOption
 @param format format
 @param ... format arguments
 */
FOUNDATION_EXTERN void CCPrintf(CCStyle style, NSString *format, ...);
