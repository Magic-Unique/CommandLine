//
//  CLSelectItem.h
//  CommandLine
//
//  Created by 吴双 on 2019/10/30.
//

#import <Foundation/Foundation.h>

@interface CLSelectItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) BOOL highlight;

@end
