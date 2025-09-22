//
//  ShortItemComponent.h
//  CKTest
//
//  Created by ductd on 22/9/25.
//


//
//  ShortItemComponent.h
//  CKTest
//

#import <ComponentKit/ComponentKit.h>

/// Dumb “short” tile (thumbnail) component.
/// Model: URL string for the image.
@interface ShortItemComponent : CKCompositeComponent
+ (instancetype)newWithURLString:(NSString *)urlString;
@end

