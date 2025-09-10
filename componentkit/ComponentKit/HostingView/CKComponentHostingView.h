/*
 *  Copyright (c) 2014-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the BSD-style license found in the
 *  LICENSE file in the root directory of this source tree. An additional grant
 *  of patent rights can be found in the PATENTS file in the same directory.
 *
 */

#import <UIKit/UIKit.h>

#import <ComponentKit/CKMacros.h>
#import <ComponentKit/CKComponentProvider.h>
#import <ComponentKit/CKUpdateMode.h>

@protocol CKComponentHostingViewDelegate;
@protocol CKComponentSizeRangeProviding;

/** A view that renders a single component. */
@interface CKComponentHostingView : UIView

/** Notified when the view's ideal size (measured by -sizeThatFits:) may have changed. */
@property (nonatomic, weak) id<CKComponentHostingViewDelegate> delegate;

/** Designated initializer. */
- (instancetype)initWithComponentProvider:(Class<CKComponentProvider>)componentProvider
                        sizeRangeProvider:(id<CKComponentSizeRangeProviding>)sizeRangeProvider;

/** Updates the model used to render the component. */
- (void)updateModel:(id<NSObject>)model mode:(CKUpdateMode)mode;
@property (nonatomic) id<NSObject> model;

/** Updates the context used to render the component. */
- (void)updateContext:(id<NSObject>)context mode:(CKUpdateMode)mode;
@property (nonatomic, readonly) id<NSObject> context;

- (instancetype)init CK_NOT_DESIGNATED_INITIALIZER_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame CK_NOT_DESIGNATED_INITIALIZER_ATTRIBUTE;

@property (nonatomic, readonly) BOOL isScopeRootReady;
/*!
 * Manual announce event CKComponentAnnouncedEventTreeWillAppear to scope root's controllers.
 * Used for standalone CKComponentHostingView.
 */
- (void)announceWillAppear;

/*!
 * Manual announce event CKComponentAnnouncedEventTreeDidDisappear to scope root's controllers.
 * Used for standalone CKComponentHostingView.
 */
- (void)announceDidDisappear;
@end
