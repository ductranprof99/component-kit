//
//  CustomTextView.m
//  CKTest
//
//  Created by ductd on 24/9/25.
//

#import "CustomTextView.h"
#import "ExpandableLabel.h"
#import <ComponentKit/CKComponent.h>
#import <ComponentKit/CKComponentViewConfiguration.h>
#import <ComponentKit/CKComponentViewAttribute.h>
#import <ComponentKit/CKComponentAction.h>

@implementation CustomTextViewState

+ (instancetype)newWithExpanded:(BOOL)expanded {
    auto ins = [[CustomTextViewState alloc] init];
    ins -> isExpanded = expanded;
    return ins;
}

- (BOOL) getIsExpand {
    return isExpanded;
}
@end

@implementation CustomTextView

+ (id)initialState {
    return [CustomTextViewState newWithExpanded: FALSE];
}

+ (instancetype)newWithTextAttribute:(const CKLabelAttributes &)attributes
                                size:(const CKComponentSize &)size
                           lineLimit: (int) numberOfLimitLine
{
    CKComponentScope scope(self);
    CustomTextViewState *state = scope.state();
    
    // Build NSAttributedString from CKLabelAttributes (font, color, etc.)
    NSMutableParagraphStyle *ps = [NSMutableParagraphStyle new];
    ps.alignment = attributes.alignment;
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *baseAttrs = @{
        NSFontAttributeName: (attributes.font ?: [UIFont systemFontOfSize:15]),
        NSForegroundColorAttributeName: (id)(attributes.color ?: [UIColor labelColor]),
        NSParagraphStyleAttributeName: ps
    };
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:(attributes.string) attributes:baseAttrs];
    
    // Bridge actions from the view back to this component
    const CKTypedComponentAction<NSNumber *> onMeasured = {scope, @selector(_heightDidChange:)};
    const CKTypedComponentAction<id> onClicked = {scope, @selector(_didTapSeeMore)};
    void (^actionBlock)(ExpandableLabelActionType, id) = ^(ExpandableLabelActionType type, id info){
        if (type == ExpandableLabelActionClick) {
//            CKComponentActionSend(onClicked, nil);
        } else if (type == ExpandableLabelActionDidCalculate) {
//            CKComponentActionSend(onMeasured, info);
        }
    };
    
    CKComponent *core = [
        CKComponent
        newWithView: {
            [ExpandableLabel class],
            {
                { @selector(setAttributedText:), attr },
                { @selector(setMaximumLines:), (NSUInteger)MAX(1, numberOfLimitLine) },
                { @selector(setIsExpanded:), state ? [state getIsExpand] : NO },
                { @selector(setAction:), actionBlock },
            }
        }
        size: size
    ];
    
    return [super newWithComponent:core];
}


- (void)_didTapSeeMore {
    [self updateState:^id(CustomTextViewState *s) {
        if (!s) { s = [CustomTextViewState newWithExpanded:NO]; }
        if (s.getIsExpand) {
            return [CustomTextViewState newWithExpanded:NO];
        } else {
            return [CustomTextViewState newWithExpanded:YES];
            
        }
    }];
}

- (void)_heightDidChange:(NSNumber *)heightNumber {
    (void)heightNumber;
}

@end
