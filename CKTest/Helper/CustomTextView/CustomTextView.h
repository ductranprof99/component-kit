//
//  CustomTextView.h
//  CKTest
//
//  Created by ductd on 24/9/25.
//

#import <ComponentKit/ComponentKit.h>
#import <ComponentKit/CKComponentAction.h>

@interface CustomTextView : CKCompositeComponent
+ (instancetype)newWithTextAttribute:(const CKLabelAttributes &)attributes
                                size: (const CKComponentSize &)size;

// Helpers to prepare text values
- (void)didTap:(id)sender;
+ (CKLabelAttributes *)truncatedAttributedStringFor:(CKLabelAttributes *)full
                         lineLimit:(NSUInteger)lineLimit;

@end
