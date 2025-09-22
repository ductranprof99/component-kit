//
//  CustomTextView.mm
//  CKTest
//
//  Created by Duc Tran on 21/9/25.
//

#import "CustomTextView.h"

#pragma mark - Component Private Interface

@interface CustomTextView ()
{
    NSString *_placeholder;
    NSString *_text;
    UIFont *_font;
    UIColor *_textColor;
    UIColor *_backgroundColor;
    CKTypedComponentAction<NSString *> _onReturn;
    CKTypedComponentAction<NSString *> _onEndEditing;
}
- (CKTypedComponentAction<NSString *>)onReturnAction;
- (CKTypedComponentAction<NSString *>)onEndEditingAction;
- (NSString *)placeholderValue;
- (NSString *)initialTextValue;
- (UIFont *)fontValue;
- (UIColor *)textColorValue;
- (UIColor *)backgroundColorValue;
@end
#pragma mark - Component

@implementation CustomTextView
+ (instancetype)newWithPlaceholder:(NSString *)placeholder
                              text:(NSString *)text
                              size: (CKComponentSize) size
                               font:(UIFont *)font
                           textColor:(UIColor *)textColor
                     backgroundColor:(UIColor *)backgroundColor
                           onReturn:(const CKTypedComponentAction<NSString *> &)onReturn
                       onEndEditing:(const CKTypedComponentAction<NSString *> &)onEndEditing
{
    CKComponentScope scope(self);
    CustomTextView *c = (CustomTextView *)[super newWithSize:size accessibility:{}];
    if (c) {
        c-> _placeholder = [placeholder copy];
        c-> _text = [text copy];
        c->_font = font;
        c->_textColor = textColor;
        c->_backgroundColor = backgroundColor;
        c-> _onReturn = onReturn;
        c-> _onEndEditing = onEndEditing;
    }
    return c;
}

- (CKTypedComponentAction<NSString *>)onReturnAction { return _onReturn; }
- (CKTypedComponentAction<NSString *>)onEndEditingAction { return _onEndEditing; }
- (NSString *)placeholderValue { return _placeholder; }
- (NSString *)initialTextValue { return _text; }
- (UIFont *)fontValue { return _font; }
- (UIColor *)textColorValue { return _textColor; }
- (UIColor *)backgroundColorValue { return _backgroundColor; }
@end

#pragma mark - Controller

@implementation CustomTextViewController

+ (UIView *)newStatefulView:(id)context
{
    UITextView *tv = [UITextView new];
    tv.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    tv.returnKeyType = UIReturnKeyDone;
    tv.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
    tv.scrollEnabled = YES;
    return tv;
}

+ (void)configureStatefulView:(UIView *)statefulView forComponent:(CKComponent *)component
{
    UITextView *tv = (UITextView *)statefulView;
    CustomTextView *ctv = (CustomTextView *)component;
    UIFont *font = [ctv fontValue];
    UIColor *tc = [ctv textColorValue];
    UIColor *bg = [ctv backgroundColorValue];
    if (font) tv.font = font;
    if (tc) tv.textColor = tc;
    if (bg) tv.backgroundColor = bg;
    // Only apply text if different, and avoid clobbering user typing.
    if (!tv.isFirstResponder) {
        NSString *desired = [ctv initialTextValue] ?: @"";
        if (![tv.text isEqualToString:desired]) {
            tv.text = desired;
        }
    }
}

- (void)didAcquireStatefulView:(UIView *)statefulView
{
    [super didAcquireStatefulView:statefulView];
    UITextView *tv = (UITextView *)statefulView;
    tv.delegate = self;
}

- (void)willRelinquishStatefulView:(UIView *)statefulView
{
    [super willRelinquishStatefulView:statefulView];
    UITextView *tv = (UITextView *)statefulView;
    if (tv.delegate == self) tv.delegate = nil;
    [tv endEditing:YES];
}

- (BOOL)canRelinquishStatefulView
{
    UITextView *tv = (UITextView *)self.statefulView;
    return tv ? !tv.isFirstResponder : YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        CustomTextView *ctv = (CustomTextView *)self.component;
        if (ctv) {
            CKTypedComponentAction<NSString *> action = [ctv onReturnAction];
            if (action) {
              action.send(ctv, textView.text ?: @"");
            }
        }
        [textView resignFirstResponder];
        return NO; // prevent newline
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    CustomTextView *ctv = (CustomTextView *)self.component;
    if (ctv) {
//        CKComponentActionSend(<#const CKTypedComponentAction<id> &action#>, <#CKComponent *sender#>, <#id context#>)
        CKTypedComponentAction<NSString *> action = [ctv onEndEditingAction];
        if (action) {
          action.send(ctv, textView.text ?: @"");
        }
    }
}

@end
