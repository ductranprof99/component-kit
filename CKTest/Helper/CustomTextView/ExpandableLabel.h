//
//  ExpandableLabel.h
//  CKTest
//
//  An old-school expandable label that owns an inner content view which does CoreText drawing.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ExpandableLabelActionClick,
    ExpandableLabelActionDidCalculate
} ExpandableLabelActionType;

@interface ExpandableLabelContentView: UIView
@end



@interface ExpandableLabel : UIView

@property(nonatomic,copy)NSAttributedString *attributedText;
@property(nonatomic)NSUInteger maximumLines;

@property(nonatomic,copy)void(^action)(ExpandableLabelActionType type, id info);

@end
