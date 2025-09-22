//
//  CustomScrollView.h
//  CKTest
//
//  Created by ductd on 22/9/25.
//

#import "CustomScrollView.h"

#pragma mark - Component

@implementation CustomScrollView

+ (instancetype)newWithSize:(CKComponentSize)size
                       axis:(CSVScrollAxis)axis
              contentInsets:(UIEdgeInsets)contentInsets
showsVerticalScrollIndicator:(BOOL)showsVerticalIndicator
showsHorizontalScrollIndicator:(BOOL)showsHorizontalIndicator
                    bounces:(BOOL)bounces
                    content:(CKComponent *)content
                    onScroll:(const CKTypedComponentAction<CGPoint> &)onScroll
{
    CKComponentScope scope(self);
    CustomScrollView *c = (CustomScrollView *)[super newWithSize:size accessibility:{}];
    if (c) {
        c->_axis     = axis;
        c->_insets   = contentInsets;
        c->_showsV   = showsVerticalIndicator;
        c->_showsH   = showsHorizontalIndicator;
        c->_bounces  = bounces;
        c->_content  = content;
        c->_onScroll = onScroll;
    }
    return c;
}

- (BOOL)bounces {
    return _bounces;
}

- (CKComponent *)content {
    return _content;
}

- (UIEdgeInsets)insets {
    return _insets;
}

- (CKTypedComponentAction<CGPoint>)onScroll {
    return _onScroll;
}

- (BOOL)showsH {
    return _showsH;
}

- (BOOL)showsV {
    return _showsV;
}

- (CSVScrollAxis)axis {
    return _axis;
}

@end

#pragma mark - Controller

@implementation CustomScrollViewController

+ (UIView *)newStatefulView:(id)context
{
    // Only create the UIScrollView here; install the hosting view in configure (when axis is known).
    UIScrollView *sv = [UIScrollView new];
    sv.clipsToBounds = YES;
    sv.directionalLockEnabled = YES;
    return sv;
}

+ (void)configureStatefulView:(UIView *)statefulView forComponent:(CKComponent *)component
{
    UIScrollView *sv = (UIScrollView *)statefulView;
    CustomScrollView *csv = (CustomScrollView *)component;
    
    // Axis/behavior
    sv.contentInset = csv.insets;
    sv.showsVerticalScrollIndicator   = csv.showsV;
    sv.showsHorizontalScrollIndicator = csv.showsH;
    sv.bounces = csv.bounces;
    sv.alwaysBounceVertical   = (csv.axis == CSVScrollAxisVertical);
    sv.alwaysBounceHorizontal = (csv.axis == CSVScrollAxisHorizontal);
    
    // Ensure a hosting view exists with the correct sizeRangeProvider (init-only).
    CKComponentHostingView *hosting =
    CSVInstallHostingViewIfNeeded(sv, (id<CKComponentHostingViewDelegate>)self.controllerInstance, csv.axis);
    
    // Feed content via the real API
    if (csv.content) {
        [hosting updateModel:csv.content mode:CKUpdateModeSynchronous];
    }
    
    // Update axis-size constraint to reflect current content.
    CSVUpdateAxisSizeConstraint(sv, hosting, csv.axis);
}

- (void)didAcquireStatefulView:(UIView *)statefulView
{
    [super didAcquireStatefulView:statefulView];
    UIScrollView *sv = (UIScrollView *)statefulView;
    sv.delegate = self;
    
    // If a hosting view already exists (after the first configure), ensure delegate is set on *instance*.
    CKComponentHostingView *hosting =
    (CKComponentHostingView *)objc_getAssociatedObject(sv, kHostingViewKey);
    if (hosting) hosting.delegate = self;
}

- (void)willRelinquishStatefulView:(UIView *)statefulView
{
    [super willRelinquishStatefulView:statefulView];
    UIScrollView *sv = (UIScrollView *)statefulView;
    if (sv.delegate == self) sv.delegate = nil;
}

#pragma mark - CKComponentHostingViewDelegate

- (void)componentHostingViewDidInvalidateSize:(CKComponentHostingView *)hostingView
{
    // Recompute the axis-length whenever the ideal size changes.
    UIScrollView *sv = (UIScrollView *)hostingView.superview;
    if (![sv isKindOfClass:UIScrollView.class]) return;
    
    CustomScrollView *csv = (CustomScrollView *)self.component;
    if (!csv) return;
    
    CSVUpdateAxisSizeConstraint(sv, hostingView, csv.axis);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CustomScrollView *csv = (CustomScrollView *)self.component;
    if (!csv) return;
    if (csv.onScroll) {
        csv.onScroll.send(csv, scrollView.contentOffset);
    }
}

#pragma mark - Convenience

/// Access to the controller instance inside +configure… (bridged via objc_getAssociatedObject on the view’s layer).
+ (instancetype)controllerInstance
{
    // In CKStatefulViewComponentController, +configure… is a class method.
    // We can safely get the current instance via [CKStatefulViewComponentController instanceForStatefulView:].
    // If your version doesn’t expose that, we simply set the delegate in -didAcquireStatefulView: (already done).
    return nil;
}

@end
