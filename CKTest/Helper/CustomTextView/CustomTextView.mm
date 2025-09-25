//
//  CustomTextView.m
//  CKTest
//
//  Created by ductd on 24/9/25.
//


#import "CustomTextView.h"

@implementation CustomTextView

+ (id)initialState
{
  return @NO;
}

+ (instancetype)newWithTextAttribute: (const CKLabelAttributes &)attributes
                                size: (const CKComponentSize &)size
{
    
    CKComponentScope scope(self);
    NSNumber *state = scope.state();
    CKLabelAttributes att = {
        .string = attributes.string,
        .maximumNumberOfLines = static_cast<NSUInteger>(state.boolValue ? 0 : 3),
        .color = attributes.color,
        .lineBreakMode = NSLineBreakByTruncatingTail,
        .font = attributes.font
    };
  

    CKComponent *label = [
        CKLabelComponent
        newWithLabelAttributes: att
        viewAttributes:{
            { @selector(setBackgroundColor:), [UIColor clearColor] }
        }
        size:{}
    ];
    
    CKComponent *tapArea = nil;
    if (!state.boolValue) {
        tapArea = [
            CKComponent
            newWithView:{
                [UIView class],
                { { CKComponentTapGestureAttribute(@selector(didTap:)) } }
            }
            size:{}
        ];
    } else {
        tapArea = [CKComponent newWithView:{} size:{}];
    }
    
    CKComponent *overlay = [
        CKOverlayLayoutComponent
        newWithComponent:label
        overlay: tapArea
    ];
    
    // Hide button (only when expanded).
    CKComponent *hideButton = nil;
    if (state.boolValue) {
        hideButton = [
            CKLabelComponent
            newWithLabelAttributes: {
                .string = @"Hide",
                .color = [UIColor redColor]
            }
            viewAttributes: {
                { @selector(setBackgroundColor:), [UIColor clearColor] },
                { { CKComponentTapGestureAttribute(@selector(didTap:)) } }
            }
            size:{
                .width = CKRelativeDimension::Points(20)
            }
        ];
    }
    
    auto child = [
        CKStackLayoutComponent
        newWithView:{}
        size: size
        style:{
            .direction = CKStackLayoutDirectionVertical,
            .alignItems = CKStackLayoutAlignItemsStretch,
            .spacing = 8
        }
        children:{
            {overlay, .flexGrow = 0, .flexShrink = 0},
            {hideButton}
        }];
    
    return [super newWithComponent:child];
}

+ (CKLabelAttributes *)truncatedAttributedStringFor:(CKLabelAttributes *)full
                                          lineLimit:(NSUInteger)lineLimit
{
//    CKLabelAttributes copy = full;
//    copy.maximumNumberOfLines = lineLimit > 0 ? lineLimit : 3;
//    copy.lineBreakMode = NSLineBreakByTruncatingTail;
    return nil;
}
- (void)didTap:(id)sender {
    // Flip expanded/collapsed and update layout immediately.
    [self updateState:^id(NSNumber *oldState) {
        BOOL wasExpanded = oldState.boolValue;
        return @( !wasExpanded );
    } mode:CKUpdateModeSynchronous];
}

@end
