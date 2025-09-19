//
//  UIColor.h
//  CKTest
//
//  Created by ductd on 19/9/25.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)

/// Create color from 0xRRGGBB (e.g. 0xFF9900). Alpha = 1.0
+ (UIColor *)colorWithHex:(uint32_t)rgb;

/// Create color from 0xRRGGBB with alpha 0.0~1.0
+ (UIColor *)colorWithHex:(uint32_t)rgb alpha:(CGFloat)alpha;

/// Create color from string: "#RGB", "#RRGGBB", "#AARRGGBB", "0xRRGGBB", "RRGGBB", "AARRGGBB"
+ (nullable UIColor *)colorWithHexString:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END