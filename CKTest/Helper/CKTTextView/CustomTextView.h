//
//  CustomTextView.h
//  CKTest
//
//  Created by Duc Tran on 21/9/25.
//

#import <ComponentKit/CKStatefulViewComponent.h>
#import <ComponentKit/ComponentKit.h>
#import <UIKit/UIKit.h>
#import <ComponentKit/CKStatefulViewComponentController.h>

@interface CustomTextView : CKStatefulViewComponent

/// Create a persistent UITextField wrapped by a stateful component.
/// The view instance is kept across rebuilds; callbacks are delivered via typed actions.
+ (instancetype)newWithPlaceholder:(NSString *)placeholder
                              text:(NSString *)text
                              size: (CKComponentSize) size
                               font:(UIFont *)font
                           textColor:(UIColor *)textColor
                     backgroundColor:(UIColor *)backgroundColor
                           onReturn:(const CKTypedComponentAction<NSString *> &)onReturn
                       onEndEditing:(const CKTypedComponentAction<NSString *> &)onEndEditing;

- (NSString *) getCurrentString;

@end


@interface CustomTextViewController : CKStatefulViewComponentController <UITextViewDelegate>
@end
