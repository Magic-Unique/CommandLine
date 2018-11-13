//
//  CLLanguage+Private.h
//  CommandLine
//
//  Created by 吴双 on 2018/11/13.
//

#import "CLLanguage.h"

@interface CLLanguage (Private)

@property (readonly) NSString *versionExplain;

@property (readonly) NSString *helpExplain;

@property (readonly) NSString *verboseExplain;

@property (readonly) NSString *helpUsage;

@property (readonly) NSString *helpCommands;

@property (readonly) NSString *helpRequires;

@property (readonly) NSString *helpOptions;

@property (readonly) NSString *helpCommand;

+ (NSString *)objectForKeyedSubscript:(NSString *)key;

@end
