//
//  UIColor.m
//  CKTest
//
//  Created by ductd on 19/9/25.
//


#import "UIColor+Hex.h"

static inline uint8_t _hexByte(NSString *s, NSUInteger idx) {
    unsigned int v = 0;
    [[NSScanner scannerWithString:[s substringWithRange:NSMakeRange(idx, 2)]] scanHexInt:&v];
    return (uint8_t)v;
}

@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(uint32_t)rgb {
    CGFloat r = ((rgb >> 16) & 0xFF) / 255.0;
    CGFloat g = ((rgb >>  8) & 0xFF) / 255.0;
    CGFloat b = ( rgb        & 0xFF) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

+ (UIColor *)colorWithHex:(uint32_t)rgb alpha:(CGFloat)alpha {
    CGFloat r = ((rgb >> 16) & 0xFF) / 255.0;
    CGFloat g = ((rgb >>  8) & 0xFF) / 255.0;
    CGFloat b = ( rgb        & 0xFF) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    if (hexString.length == 0) return nil;

    // Normalize: remove whitespace, leading '#', '0x', etc.
    NSString *s = [[hexString stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    if ([s hasPrefix:@"#"])     s = [s substringFromIndex:1];
    else if ([s hasPrefix:@"0X"]) s = [s substringFromIndex:2];

    NSUInteger len = s.length;

    // #RGB -> #RRGGBB
    if (len == 3) {
        unichar r = [s characterAtIndex:0];
        unichar g = [s characterAtIndex:1];
        unichar b = [s characterAtIndex:2];
        s = [NSString stringWithFormat:@"%C%C%C%C%C%C", r,r, g,g, b,b];
        len = 6;
    }

    // Accept 6 (RRGGBB) or 8 (AARRGGBB)
    if (len != 6 && len != 8) return nil;

    uint8_t a = 255, r = 0, g = 0, b = 0;

    if (len == 8) {
        a = _hexByte(s, 0);
        r = _hexByte(s, 2);
        g = _hexByte(s, 4);
        b = _hexByte(s, 6);
    } else { // 6
        r = _hexByte(s, 0);
        g = _hexByte(s, 2);
        b = _hexByte(s, 4);
    }

    return [UIColor colorWithRed:r/255.0
                           green:g/255.0
                            blue:b/255.0
                           alpha:a/255.0];
}

@end
