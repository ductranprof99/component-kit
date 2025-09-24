//
//  NSDate+Date_Extension.h
//  CKTest
//
//  Created by ductd on 24/9/25.
//

#import <Foundation/Foundation.h>

@interface NSDate (Custom)
- (NSString *_Nullable)stringDisplayToCurrent;

+ (nullable NSDate *)ck_dateFromFlexible:(id _Nullable )value;
@end
