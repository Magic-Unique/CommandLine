//
//  CLIOPath.m
//  CommandLineDemo
//
//  Created by Unique on 2018/5/19.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLIOPath.h"

@implementation CLIOPath

- (instancetype)initWithKey:(NSString *)key index:(NSUInteger)index require:(BOOL)require {
    self = [super initWithKey:key index:index];
    if (self) {
        _isRequire = require;
    }
    return self;
}

- (void)setExplain:(NSString *)explain {
    _explain = explain;
}

- (void)setExample:(NSString *)example {
    _example = example;
}

- (NSString *)title {
    return [self titleWithAbbr:NO];
}

- (NSString *)titleWithAbbr:(BOOL)abbr {
    NSString *contents = self.example?:self.key;
    return self.isRequire ? [NSString stringWithFormat:@"<%@>", contents] : [NSString stringWithFormat:@"[%@]", contents];
}

- (NSString *)subtitle {
    return self.explain?:@"";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<IOPath key=%@ %@>: %@", self.key, _isRequire?@"require":@"optional", _explain];
}

+ (NSString *)abslutePath:(NSString *)relativePath {
    if (relativePath == nil) {
        return nil;
    }
    
    if (relativePath == 0) {
        relativePath = @".";
    }
    
    if ([relativePath hasPrefix:@"~"]) {
        relativePath = [relativePath stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[self homeDirectory]];
    }
    
    else if (![relativePath hasPrefix:@"/"]) {
        relativePath = [[self currentDirectory] stringByAppendingPathComponent:relativePath];
    }
    
    NSMutableArray *folders = [NSMutableArray arrayWithArray:[relativePath componentsSeparatedByString:@"/"]];
    
    NSMutableArray *formatFolders = [NSMutableArray array];
    for (NSString *folder in folders) {
        if (folder.length == 0) {
            continue;
        }
        
        if ([folder isEqualToString:@"."]) {
            continue;
        } else if ([folder isEqualToString:@".."]) {
            [formatFolders removeLastObject];
        } else {
            [formatFolders addObject:folder];
        }
    }
    
    NSMutableString *abslutePath = [NSMutableString string];
    for (NSString *folder in formatFolders) {
        [abslutePath appendFormat:@"/%@", folder];
    }
    
    return [abslutePath copy];
}

+ (NSString *)currentDirectory {
    char *buffer = getcwd(NULL, 0);
    NSString *cwd = [NSString stringWithUTF8String:buffer];
    free(buffer);
    return cwd;
}

+ (NSString *)homeDirectory {
    return NSHomeDirectory();
}

@end

@implementation CLIOPath (Definer)

- (CLIOPath *(^)(NSString *))setExplain {
    return ^CLIOPath *(NSString *explain) {
        self.explain = explain;
        return self;
    };
}

- (CLIOPath *(^)(NSString *))setExample {
    return ^CLIOPath *(NSString *example) {
        self.example = example;
        return self;
    };
}

@end
