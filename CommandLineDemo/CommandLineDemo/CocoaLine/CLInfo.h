//
//  CLArgumentInfo.h
//  CommandLineDemo
//
//  Created by 吴双 on 2022/10/19.
//  Copyright © 2022 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLBaseInfo : NSObject

@property (readonly) NSString *name;

@property NSString *type;

@property NSString *note;

- (instancetype)initWithName:(NSString *)name;

@end



@interface CLOptionInfo : CLBaseInfo

@property char shortName;

@property BOOL required;

@property (readonly) BOOL isBOOL;

@end


@interface CLArgumentInfo : CLBaseInfo

@property BOOL isArray;

@property NSUInteger index;

@end




@interface CLCommandInfo : CLBaseInfo

@property (nonatomic, strong) NSMutableDictionary<NSString *, CLBaseInfo *> *properties;
@property (nonatomic, strong) NSMutableDictionary<NSString *, CLOptionInfo *> *options;
@property (nonatomic, strong) NSMutableDictionary<NSString *, CLArgumentInfo *> *arguments;

- (CLOptionInfo *)optionInfoForName:(NSString *)name;
- (CLOptionInfo *)optionInfoForShortName:(char)shortName;

@end
