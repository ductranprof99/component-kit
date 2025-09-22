//
//  CustomScrollView.h
//  CKTest
//
//  Created by ductd on 22/9/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <ComponentKit/ComponentKit.h>
#import <ComponentKit/CKStatefulViewComponent.h>
#import <ComponentKit/CKStatefulViewComponentController.h>
#import <ComponentKit/CKComponentAction.h>


#pragma mark - Constant (Associated keys)
typedef NS_ENUM(NSInteger, CSVScrollAxis) {
  CSVScrollAxisVertical = 0,
  CSVScrollAxisHorizontal = 1,
};

static void *kHostingViewKey        = &kHostingViewKey;
static void *kAxisKey               = &kAxisKey;
static void *kWidthEqKey            = &kWidthEqKey;
static void *kHeightEqKey           = &kHeightEqKey;
static void *kAxisSizeConstraintKey = &kAxisSizeConstraintKey;

#pragma mark - Provider
/// Minimal provider: treat the model as a CKComponent* root.
@interface CSVHostingProvider : NSObject <CKComponentProvider>
@end


#pragma mark - Component
/**
 A stateful UIScrollView wrapper that hosts a CK component tree via CKComponentHostingView.
 Axis is fixed per instance (required because sizeRangeProvider is init-only).
 */
@interface CustomScrollView : CKStatefulViewComponent
{
    CSVScrollAxis _axis;
    UIEdgeInsets  _insets;
    BOOL          _showsV;
    BOOL          _showsH;
    BOOL          _bounces;
    CKComponent  *_content;
    CKTypedComponentAction<CGPoint> _onScroll;
}

+ (instancetype)newWithSize:(CKComponentSize)size
                       axis:(CSVScrollAxis)axis
              contentInsets:(UIEdgeInsets)contentInsets
showsVerticalScrollIndicator:(BOOL)showsVerticalIndicator
showsHorizontalScrollIndicator:(BOOL)showsHorizontalIndicator
                    bounces:(BOOL)bounces
                    content:(CKComponent *)content
                    onScroll:(const CKTypedComponentAction<CGPoint> &)onScroll;


- (CSVScrollAxis)axis;
- (UIEdgeInsets)insets;
- (BOOL)showsV;
- (BOOL)showsH;
- (BOOL)bounces;
- (CKComponent *)content;
- (CKTypedComponentAction<CGPoint>)onScroll;
@end

#pragma mark - Controller
@interface CustomScrollViewController : CKStatefulViewComponentController
  <UIScrollViewDelegate, CKComponentHostingViewDelegate>
@end

#pragma mark - Helper
inline CKComponentFlexibleSizeRangeProvider *
CSVMakeSizeRangeProvider(CSVScrollAxis axis);

CKComponentHostingView *
CSVInstallHostingViewIfNeeded(UIScrollView *sv,
                              id<CKComponentHostingViewDelegate> delegate,
                              CSVScrollAxis axis);

void CSVUpdateAxisSizeConstraint(
        UIScrollView *sv,
        CKComponentHostingView *hosting,
        CSVScrollAxis axis
);
