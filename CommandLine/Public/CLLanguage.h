//
//  CLLanguage.h
//  CommandLine
//
//  Created by 吴双 on 2018/11/13.
//

#import <Foundation/Foundation.h>

typedef NSString *CLLanguageKey;

/** Explain for version flag */
FOUNDATION_EXTERN CLLanguageKey const CLVersionExplainLanguageKey;
/** Explain for help flag */
FOUNDATION_EXTERN CLLanguageKey const CLHelpExplainLanguageKey;
/** Explain for verbose flag */
FOUNDATION_EXTERN CLLanguageKey const CLVerboseExplainLanguageKey;


/** `Usage` keyword in helping information */
FOUNDATION_EXTERN CLLanguageKey const CLHelpUsageLanguageKey;
/** `Commands` keyword in helping information */
FOUNDATION_EXTERN CLLanguageKey const CLHelpCommandsLanguageKey;
/** `Requires` keyword in helping infomation */
FOUNDATION_EXTERN CLLanguageKey const CLHelpRequiresLanguageKey;
/** `Options` keyword in helping information */
FOUNDATION_EXTERN CLLanguageKey const CLHelpOptionsLanguageKey;

/** `COMMAND` placeholder for sub command in helping infomation */
FOUNDATION_EXTERN CLLanguageKey const CLHelpCommandLanguageKey;


#define CLCurrentLanguage (CLLanguage.current)

@interface CLLanguage : NSObject


/**
 Current Language, default is +EnglishLanguage

 @return CLLanguage
 */
+ (instancetype)current;



/**
 Chinese Language

 @return CLLanguage
 */
+ (instancetype)ChineseLanguage;


/**
 English Language

 @return CLLanguage
 */
+ (instancetype)EnglishLanguage;


/**
 Make a custom language

 @param strings NSDictionary, key is CLLanguageKey, value is NSString
 @return CLLanguage
 */
+ (instancetype)languageWithStrings:(NSDictionary<CLLanguageKey, NSString *> *)strings;


/**
 Make a custom language with block

 @param mapBlock set all keys value in block
 @return CLLanguage
 */
+ (instancetype)languageWithMapBlock:(void (^)(NSMutableDictionary<CLLanguageKey, NSString *> *strings))mapBlock;


/**
 Get language value

 @param key CLLanguageKey
 @return NSString
 */
- (NSString *)objectForKeyedSubscript:(CLLanguageKey)key;


/**
 Set language value

 @param obj NSString
 @param key CLLanguageKey
 */
- (void)setObject:(NSString *)obj forKeyedSubscript:(CLLanguageKey)key;


/**
 Apply as current language
 */
- (void)apply;

@end
