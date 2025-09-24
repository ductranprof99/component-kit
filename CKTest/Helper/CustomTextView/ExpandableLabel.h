//
//  ExpandableLabel.h
//  CKTest
//
//  An old-school expandable label that owns an inner content view which does CoreText drawing.
//

#import <UIKit/UIKit.h>
#import <ComponentKit/CKComponentAction.h>

typedef enum : NSUInteger {
    ExpandableLabelActionClick,
    ExpandableLabelActionDidCalculate
} ExpandableLabelActionType;

@interface ExpandableLabelContentView: UIView
@end



@interface ExpandableLabel : UIView

@property(nonatomic,copy)NSAttributedString *attributedText;
@property(nonatomic)NSUInteger maximumLines;
@property(nonatomic, assign) BOOL isExpanded;

@property(nonatomic,copy)void(^action)(ExpandableLabelActionType type, id info);

- (NSAttributedString *)attrString;
- (NSUInteger)lineLimit;
- (CKTypedComponentAction<NSNumber *>)onMeasured;
- (CKTypedComponentAction<id>)onClick;
- (BOOL)isExpandedState;

@end

@interface ExpandableLabel()

#pragma mark - Private Properties
@property(nonatomic,copy)NSAttributedString *clickAttributedText;
@property(nonatomic,copy)ExpandableLabelContentView *contentView;
@property(nonatomic)CGRect clickArea;

@property(nonatomic, assign) CGFloat measuredHeight;
@property(nonatomic, assign) CGFloat lastMeasuredWidth;
@property(nonatomic, strong) NSAttributedString *lastDrawAttributedText;

@end
