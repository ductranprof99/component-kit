//
//  CSVHostingProvider.h
//  CKTest
//
//  Created by ductd on 22/9/25.
//


//
//  CustomScrollView.mm
//

#import "CustomScrollView.h"

#import <objc/runtime.h>
#import <ComponentKit/CKComponentHostingView.h>
#import <ComponentKit/CKComponentHostingViewDelegate.h>
#import <ComponentKit/CKComponentFlexibleSizeRangeProvider.h>
#import <ComponentKit/CKStackLayoutComponent.h>

#pragma mark - Associated keys

static void *kHostingViewKey        = &kHostingViewKey;
static void *kAxisKey               = &kAxisKey;
static void *kWidthEqKey            = &kWidthEqKey;
static void *kHeightEqKey           = &kHeightEqKey;
static void *kAxisSizeConstraintKey = &kAxisSizeConstraintKey;

#pragma mark - Provider

/// Minimal provider: treat the model as a CKComponent* root.
@interface CSVHostingProvider : NSObject <CKComponentProvider>
@end

@implementation CSVHostingProvider
+ (CKComponent *)componentForModel:(id<NSObject>)model context:(id<NSObject>)context
{
    if ([model isKindOfClass:[CKComponent class]]) {
        return (CKComponent *)model;
    }
    // Fallback to an empty stack to avoid returning nil.
    return [CKStackLayoutComponent newWithView:{} size:{} style:{} children:{}];
}
@end

#pragma mark - Helpers

static inline CKComponentFlexibleSizeRangeProvider *
CSVMakeSizeRangeProvider(CSVScrollAxis axis)
{
    const CKComponentSizeRangeFlexibility flex =
    (axis == CSVScrollAxisVertical)
    ? CKComponentSizeRangeFlexibleHeight   // fixed width, flexible height
    : CKComponentSizeRangeFlexibleWidth;   // fixed height, flexible width
    return [CKComponentFlexibleSizeRangeProvider providerWithFlexibility:flex];
}

static CKComponentHostingView *
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
    
    if (@available(iOS 11.0, *)) {
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
    }
    
    objc_setAssociatedObject(sv, kHostingViewKey, hosting, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(sv, kAxisKey, @(axis), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return hosting;
}

static void
CSVUpdateAxisSizeConstraint(UIScrollView *sv,
                            CKComponentHostingView *hosting,
                            CSVScrollAxis axis)
{
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
