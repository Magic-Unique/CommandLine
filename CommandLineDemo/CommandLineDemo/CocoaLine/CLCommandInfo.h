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

@property (readonly) BOOL isRequired; // private
@property (readonly) BOOL isBOOL; // private

@property (readonly) BOOL nullable;
@property (readonly) BOOL nonnull;

@end


@interface CLArgumentInfo : CLBaseInfo

@property BOOL isArray; // private
@property NSUInteger index; // private

@end




@interface CLCommandInfo : CLBaseInfo

@property (nonatomic, strong) NSMutableDictionary<NSString *, CLBaseInfo *> *properties;
@property (nonatomic, strong) NSMutableDictionary<NSString *, CLOptionInfo *> *options;
@property (nonatomic, strong) NSMutableDictionary<NSString *, CLArgumentInfo *> *arguments;

- (CLOptionInfo *)optionInfoForName:(NSString *)name;
- (CLOptionInfo *)optionInfoForShortName:(char)shortName;

@end
