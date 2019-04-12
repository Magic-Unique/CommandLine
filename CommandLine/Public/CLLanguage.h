//
//  CLLanguage.h
//  CommandLine
//
//  Created by Magic-Unique on 2018/11/13.
//

#import <Foundation/Foundation.h>

typedef NSString *CLLanguageKey;

/** Explain for version flag */
FOUNDATION_EXTERN CLLanguageKey const _Nonnull CLVersionExplainLanguageKey;
/** Explain for help flag */
FOUNDATION_EXTERN CLLanguageKey const _Nonnull CLHelpExplainLanguageKey;
/** Explain for verbose flag */
FOUNDATION_EXTERN CLLanguageKey const _Nonnull CLVerboseExplainLanguageKey;


/** `Usage` keyword in helping information */
FOUNDATION_EXTERN CLLanguageKey const _Nonnull CLHelpUsageLanguageKey;
/** `Commands` keyword in helping information */
FOUNDATION_EXTERN CLLanguageKey const _Nonnull CLHelpCommandsLanguageKey;
/** `Requires` keyword in helping infomation */
FOUNDATION_EXTERN CLLanguageKey const _Nonnull CLHelpRequiresLanguageKey;
/** `Options` keyword in helping information */
FOUNDATION_EXTERN CLLanguageKey const _Nonnull CLHelpOptionsLanguageKey;

/** `COMMAND` placeholder for sub command in helping infomation */
FOUNDATION_EXTERN CLLanguageKey const _Nonnull CLHelpCommandLanguageKey;

/** Print if user input an illegal value */
FOUNDATION_EXTERN CLLanguageKey const _Nonnull CLParseErrorIllegalValueLanguageKey;

/** Print if user input an illegal value */
FOUNDATION_EXTERN CLLanguageKey const _Nonnull CLParseErrorUnknowQueryLanguageKey;



#define CLCurrentLanguage (CLLanguage.current)

@interface CLLanguage : NSObject


/**
 Current Language, default is +EnglishLanguage

 @return CLLanguage
 */
+ (instancetype _Nonnull)current;



/**
 Chinese Language

 @return CLLanguage
 */
+ (instancetype _Nonnull)ChineseLanguage;


/**
 English Language

 @return CLLanguage
 */
+ (instancetype _Nonnull)EnglishLanguage;


/**
 Make a custom language

 @param strings NSDictionary, key is CLLanguageKey, value is NSString
 @return CLLanguage
 */
+ (instancetype _Nonnull)languageWithStrings:(NSDictionary<CLLanguageKey, NSString *> * _Nonnull)strings;


/**
 Make a custom language with block

 @param mapBlock set all keys value in block
 @return CLLanguage
 */
+ (instancetype _Nonnull)languageWithMapBlock:(void (^_Nonnull)(NSMutableDictionary<CLLanguageKey, NSString *> * _Nonnull strings))mapBlock;


/**
 Get language value

 @param key CLLanguageKey
 @return NSString
 */
- (NSString * _Nullable)objectForKeyedSubscript:(CLLanguageKey _Nonnull)key;


/**
 Set language value

 @param obj NSString
 @param key CLLanguageKey
 */
- (void)setObject:(NSString *_Nullable)obj forKeyedSubscript:(CLLanguageKey _Nonnull)key;


/**
 Apply as current language
 */
- (void)apply;

@end
