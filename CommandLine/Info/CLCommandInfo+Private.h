//
//  CLCommandInfo+Private.h
//  CommandLine
//
//  Created by Magic-Unique on 2026/6/14.
//

#import "CLCommandInfo.h"


@interface CLBaseInfo ()
@property (readonly) BOOL isRequired; // private
@end

@interface CLEnviromentInfo ()
@property (readonly) BOOL isBOOL; // private
@end


@interface CLOptionInfo ()
@property BOOL isArray; // private
@property (readonly) BOOL isBOOL; // private
@property (readonly) BOOL isShowInUsage;
@end


@interface CLArgumentInfo ()
@property BOOL isArray; // private
@property NSUInteger index; // private
@end
