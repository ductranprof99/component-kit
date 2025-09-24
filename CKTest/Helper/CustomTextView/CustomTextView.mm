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
#import <ComponentKit/CKStatefulViewComponent.h>

@implementation CustomTextViewState
{
    BOOL isExpanded;
}

+ (instancetype)newWithExpanded:(BOOL)expanded {
    auto ins = [[CustomTextViewState alloc] init];
    ins->isExpanded = expanded;
    ins.hasCalculated = NO;
    ins.calcId = 0;
    ins.measuredHeight = 0;
    return ins;
}

- (BOOL) getIsExpand {
    return isExpanded;
}
- (BOOL)getHasCalculated { return self.hasCalculated; }
- (NSInteger)getCalcId { return self.calcId; }
- (CGFloat)getMeasuredHeight { return self.measuredHeight; }
@end

@implementation CustomTextView
{
    NSAttributedString *_attrString;
    NSUInteger _lineLimit;
    CKTypedComponentAction<NSNumber *> _onMeasured;
    CKTypedComponentAction<id> _onClicked;
}

- (CKTypedComponentAction<NSNumber *>)onMeasured {
    return _onMeasured;
}

- (CKTypedComponentAction<id>)onClick {
    return _onClicked;
}

- (NSUInteger)lineLimit {
    return _lineLimit;
}

- (NSAttributedString *)attrString { return _attrString; }
- (BOOL)isExpandedState {
    //    CustomTextViewState *s = (CustomTextViewState *)[self state];
    //    return s ? [s getIsExpand] : NO;
    return NO;
}

+ (id)initialState {
    return [CustomTextViewState newWithExpanded: FALSE];
}

+ (CKComponent *)newWithTextAttribute:(const CKLabelAttributes &)attributes
                                   size:(const CKComponentSize &)size
                              lineLimit:(int)numberOfLimitLine
{
    CKComponentScope scope(self);
    CustomTextViewState *state = scope.state();
    if (!state) state = [CustomTextViewState newWithExpanded:NO];
    
    // Build attributed string once
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:attributes.string ?: @""];
    if (attributes.font)  [attr addAttribute:NSFontAttributeName value:attributes.font range:NSMakeRange(0, attr.length)];
    if (attributes.color) [attr addAttribute:NSForegroundColorAttributeName value:attributes.color range:NSMakeRange(0, attr.length)];
    
    // Typed actions from this component back into itself
    const CKTypedComponentAction<NSNumber *> onMeasured = {scope, @selector(_heightDidChange:)};
    const CKTypedComponentAction<id>        onClicked  = {scope, @selector(_didTapSeeMore:)};
    
    CustomTextView *c = (CustomTextView *)[super newWithSize:size accessibility:{}];
    if (c) {
        c->_attrString = attr;
        c->_lineLimit  = (NSUInteger)MAX(1, numberOfLimitLine);
        c->_onMeasured = onMeasured;
        c->_onClicked  = onClicked;
    }
    return c;
}


- (void)_didTapSeeMore:(id)payload {
    [self updateState:^id(CustomTextViewState *s) {
        if (!s) { s = [CustomTextViewState newWithExpanded:NO]; }
        return ({
            BOOL nextExpanded = s.getIsExpand ? NO : YES;
            auto ns = [CustomTextViewState newWithExpanded:nextExpanded];
            ns.hasCalculated = s.hasCalculated;
            ns.measuredHeight = s.measuredHeight;
            ns.calcId = s.calcId + 1;
            ns;
        });
    }];
}

- (void)_heightDidChange:(NSNumber *)heightNumber {
    [self updateState:^id(CustomTextViewState *s) {
        if (!s) { s = [CustomTextViewState newWithExpanded:NO]; }
        s.hasCalculated = YES;
        s.measuredHeight = heightNumber ? heightNumber.doubleValue : 0.0;
        s.calcId = s.calcId + 1;
        NSLog(@"[CustomTextView] measured height = %.2f (calcId=%ld, expanded=%@)", s.measuredHeight, (long)s.calcId, [s getIsExpand] ? @"YES" : @"NO");
        return s;
    }];
}

@end

@implementation CustomTextViewController

+ (UIView *)newStatefulView:(id)context
{
  ExpandableLabel *v = [ExpandableLabel new];
  v.backgroundColor = [UIColor clearColor];
  return v;
}

+ (void)configureStatefulView:(UIView *)statefulView forComponent:(CKComponent *)component
{
    ExpandableLabel *v = (ExpandableLabel *)statefulView;
    CustomTextView *c = (CustomTextView *)component;
    (void)0; // no direct state access
    if (!v || !c) return;
    
    v.attributedText = [c attrString];
    v.maximumLines   = c.lineLimit;
    v.isExpanded     = [c isExpandedState];
    //
    __weak CustomTextView *weakC = c;
    v.action = ^(ExpandableLabelActionType type, id info) {
        if (type == ExpandableLabelActionClick) {
            //            if (weakC) { CKComponentActionSend([weakC onClick], nil); }
        } else if (type == ExpandableLabelActionDidCalculate) {
            //            if (weakC) { CKComponentActionSend([weakC onMeasured], info); }
        }
    };
}

- (void)didAcquireStatefulView:(UIView *)statefulView
{
  [super didAcquireStatefulView:statefulView];
  // No-op for now; keep hook symmetry with CustomScrollView.
}

- (void)willRelinquishStatefulView:(UIView *)statefulView
{
  [super willRelinquishStatefulView:statefulView];
}

@end
