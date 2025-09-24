//
//  NSDate_Ext.m
//  CKTest
//
//  Created by ductd on 24/9/25.
//

#import "NSDate_Ext.h"

@implementation NSDate(Custom)

+ (nullable NSDate *)ck_dateFromFlexible:(id)value {
  if (!value || value == [NSNull null]) { return nil; }
  if ([value isKindOfClass:[NSDate class]]) { return (NSDate *)value; }

  // NSNumber (int/double) -> seconds or milliseconds since 1970
  if ([value isKindOfClass:[NSNumber class]]) {
    double t = [(NSNumber *)value doubleValue];
    double seconds = (fabs(t) > 1e12) ? (t / 1000.0) : t; // treat big numbers as ms
    return [NSDate dateWithTimeIntervalSince1970:seconds];
  }

  // NSString -> numeric timestamp or formatted date
  if ([value isKindOfClass:[NSString class]]) {
    NSString *s = [(NSString *)value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (s.length == 0) { return nil; }

    // Try numeric string first
    NSCharacterSet *nonNum = [[NSCharacterSet characterSetWithCharactersInString:@"-0123456789."] invertedSet];
    if ([s rangeOfCharacterFromSet:nonNum].location == NSNotFound) {
      double t = [s doubleValue];
      if (t != 0 || [s isEqualToString:@"0"]) {
        double seconds = (fabs(t) > 1e12) ? (t / 1000.0) : t;
        return [NSDate dateWithTimeIntervalSince1970:seconds];
      }
    }

    // Try ISO 8601
    if (@available(iOS 10.0, *)) {
      NSISO8601DateFormatter *iso = [[NSISO8601DateFormatter alloc] init];
      NSDate *d = [iso dateFromString:s];
      if (d) { return d; }
    }

    // Try common fallback formats
    NSArray<NSString *> *formats = @[
      @"yyyy-MM-dd'T'HH:mm:ssZ",
      @"yyyy-MM-dd'T'HH:mm:ssXXXXX",
      @"yyyy-MM-dd HH:mm:ss",
      @"yyyy/MM/dd HH:mm:ss",
      @"yyyy-MM-dd",
      @"yyyy/MM/dd",
      @"dd/MM/yyyy",
      @"dd/MM/yyyy HH:mm:ss",
      @"MM/dd/yyyy"
    ];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    df.timeZone = [NSTimeZone systemTimeZone];
    for (NSString *fmt in formats) {
      df.dateFormat = fmt;
      NSDate *d = [df dateFromString:s];
      if (d) { return d; }
    }

    return nil;
  }

  return nil;
}

- (NSString *)stringDisplayToCurrent {
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self];
    
    if (delta >= 0) {
        return @"Vừa xong";
    }
    
    if (delta < 0) {
      // Clamp future dates to now for a simple "ago" display
      delta = -delta;
    }

    NSInteger seconds = (NSInteger)floor(delta);

    if (seconds < 60) {
      return [NSString stringWithFormat:@"%ld giây trước", (long)seconds];
    }

    NSInteger minutes = seconds / 60;
    if (seconds < 3600) {
      return [NSString stringWithFormat:@"%ld phút trước", (long)minutes];
    }

    NSInteger hours = seconds / 3600;
    if (seconds < 86400) {
      return [NSString stringWithFormat:@"%ld giờ trước", (long)hours];
    }

    // Fallback for >= 24h
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    formatter.dateFormat = @"dd/MM/yyyy";
    return [formatter stringFromDate:self];
}

@end
