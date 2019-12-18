//
//  CLSelectItem.h
//  CommandLine
//
//  Created by 冷秋 on 2019/10/30.
//

#import <Foundation/Foundation.h>

@interface CLSelectItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) BOOL highlight;

@end
