//
//  CLQuery.h
//  CommandLineDemo
//
//  Created by Unique on 2018/5/15.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLExplain.h"


/**
 Query multi-type

 - CLQueryMultiTypeNone: Unsupport multi input.
 - CLQueryMultiTypeSeparatedByComma: A key and a value with separated by comma, such as: --key value1,value2
 - CLQueryMultiTypeMoreKeyValue: More keys and values, such as: --key value1 --key --value2
 */
typedef NS_ENUM(NSUInteger, CLQueryMultiType) {
    CLQueryMultiTypeNone,
    CLQueryMultiTypeSeparatedByComma,
    CLQueryMultiTypeMoreKeyValue,
};


@interface CLQuery : CLExplain

@property (nonatomic, strong, readonly, nonnull) NSString *key;

@property (nonatomic, assign, readonly) char abbr;

@property (nonatomic, strong, readonly, nullable) NSString *explain;

@property (nonatomic, assign, readonly) BOOL isOptional;

@property (nonatomic, strong, readonly, nullable) NSString *regular;

@property (nonatomic, assign, readonly) CLQueryMultiType multiType;

@property (nonatomic, strong, readonly, nullable) NSString *example;

@property (nonatomic, strong, readonly, nullable) id defaultValue;

@end





@interface CLQuery (Definer)

/**
 Mark the query as required
 */
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^require)(void);

/**
 Mark the query as optional
 */
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^optional)(void);

/**
 Set abbr
 */
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^setAbbr)(char abbr);

/**
 Set description
 */
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^setExplain)(NSString * _Nonnull explain);

/**
 Set default value. Array or String
 */
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^setDefaultValue)(id _Nonnull defaultValue);

/**
 Set example
 
 Example will be printed in help document.
 */
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^setExample)(NSString * _Nonnull example);

/**
 Set value type as String
 */
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^asString)(void);

/**
 Set value type as path
 */
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^asPath)(void);

/**
 Set value type as number
 */
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^asNumber)(void);

/**
 Set mult-value.
 
 The query can be inputed once or more, and the value will be parsed in an array.
 */
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^setMultiType)(CLQueryMultiType type);

/**
 Set value predicate.
 
 Check value with predicate.
 */
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^predicate)(NSString * _Nonnull regular);

/**
 Inherit to subcommand
 */
@property (nonatomic, readonly, nonnull) CLQuery * _Nonnull (^inheritify)(void);

- (instancetype _Nonnull)initWithKey:(NSString * _Nonnull)key;

@end




@interface CLQuery (Predicate)

- (BOOL)predicateForString:(NSString * _Nonnull)string;

@end

