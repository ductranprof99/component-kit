//
//  CustomScrollView+Helpers.m
//  CKTest
//
//  Created by ductd on 22/9/25.
//

#import "CustomScrollView.h"

#pragma mark - Helpers
inline CKComponentFlexibleSizeRangeProvider *
CSVMakeSizeRangeProvider(CSVScrollAxis axis)
{
    const CKComponentSizeRangeFlexibility flex =
    (axis == CSVScrollAxisVertical)
    ? CKComponentSizeRangeFlexibleHeight   // fixed width, flexible height
    : CKComponentSizeRangeFlexibleWidth;   // fixed height, flexible width
    return [CKComponentFlexibleSizeRangeProvider providerWithFlexibility:flex];
}

CKComponentHostingView *
CSVInstallHostingViewIfNeeded(UIScrollView *sv,
                              id<CKComponentHostingViewDelegate> delegate,
                              CSVScrollAxis axis)
{
    CKComponentHostingView *hosting =
    (CKComponentHostingView *)objc_getAssociatedObject(sv, kHostingViewKey);
    NSNumber *storedAxis = (NSNumber *)objc_getAssociatedObject(sv, kAxisKey);
    
    const BOOL needNew = (hosting == nil) || (storedAxis == nil) || (storedAxis.integerValue != axis);
    if (!needNew) return hosting;
    
    // Remove old hosting + constraints if present
    if (hosting) { [hosting removeFromSuperview]; }
    
    // Build a hosting view with the correct provider (init-only)
    CKComponentFlexibleSizeRangeProvider *provider = CSVMakeSizeRangeProvider(axis);
    hosting = [[CKComponentHostingView alloc] initWithComponentProvider:[CSVHostingProvider class]
                                                      sizeRangeProvider:provider];
    hosting.delegate = delegate;
    hosting.translatesAutoresizingMaskIntoConstraints = NO;
    [sv addSubview:hosting];
    
    UILayoutGuide *content = sv.contentLayoutGuide;
    UILayoutGuide *frame   = sv.frameLayoutGuide;
    
    // Pin hosting to content area
    [NSLayoutConstraint activateConstraints:@[
        [hosting.leadingAnchor constraintEqualToAnchor:content.leadingAnchor],
        [hosting.trailingAnchor constraintEqualToAnchor:content.trailingAnchor],
        [hosting.topAnchor constraintEqualToAnchor:content.topAnchor],
        [hosting.bottomAnchor constraintEqualToAnchor:content.bottomAnchor],
    ]];
    
    // Cross-axis equality constraint to prevent scrolling on that axis.
    NSLayoutConstraint *wEq = [hosting.widthAnchor  constraintEqualToAnchor:frame.widthAnchor];
    NSLayoutConstraint *hEq = [hosting.heightAnchor constraintEqualToAnchor:frame.heightAnchor];
    wEq.active = (axis == CSVScrollAxisVertical);
    hEq.active = (axis == CSVScrollAxisHorizontal);
    
    // Axis-size constraint we control (height for vertical, width for horizontal).
    NSLayoutConstraint *axisSize;
    if (axis == CSVScrollAxisVertical) {
        axisSize = [hosting.heightAnchor constraintEqualToConstant:0];
    } else {
        axisSize = [hosting.widthAnchor constraintEqualToConstant:0];
    }
    axisSize.priority = UILayoutPriorityRequired;
    axisSize.active = YES;
    
    objc_setAssociatedObject(sv, kWidthEqKey,  wEq,      OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(sv, kHeightEqKey, hEq,      OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(sv, kAxisSizeConstraintKey, axisSize, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(sv, kHostingViewKey, hosting, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(sv, kAxisKey, @(axis), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return hosting;
}

void CSVUpdateAxisSizeConstraint(
        UIScrollView *sv,
        CKComponentHostingView *hosting,
        CSVScrollAxis axis
) {
    NSLayoutConstraint *axisSize =
    (NSLayoutConstraint *)objc_getAssociatedObject(sv, kAxisSizeConstraintKey);
    if (!axisSize) return;
    
    // Compute the "ideal" content size along the scroll axis.
    // Use the scroll view's visible frame as the cross-axis bound.
    const CGSize frameSize = sv.bounds.size;
    CGSize fittingBound = frameSize;
    if (axis == CSVScrollAxisVertical) {
        fittingBound.height = CGFLOAT_MAX; // grow vertically
    } else {
        fittingBound.width = CGFLOAT_MAX;  // grow horizontally
    }
    
    const CGSize fit = [hosting sizeThatFits:fittingBound];
    
    // Update the constraint constant for the scroll axis.
    axisSize.constant = (axis == CSVScrollAxisVertical) ? fit.height : fit.width;
    
    // Force layout so the scroll view recalculates its contentSize from constraints.
    [sv setNeedsLayout];
    [sv layoutIfNeeded];
}
