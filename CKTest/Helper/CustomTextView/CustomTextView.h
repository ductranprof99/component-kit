//
//  CustomTextView.h
//  CKTest
//
//  Created by ductd on 24/9/25.
//

#import <ComponentKit/ComponentKit.h>

@interface CustomTextView : CKCompositeComponent
+ (instancetype)newWithTextAttribute:(const CKLabelAttributes &)attributes
                                size:(const CKComponentSize &)size
                           lineLimit: (int) numberOfLimitLine;
@end

@interface CustomTextViewState: NSObject
{
    BOOL isExpanded;
}

+ (instancetype) newWithExpanded: (BOOL) expanded;
- (BOOL) getIsExpand;
@end
