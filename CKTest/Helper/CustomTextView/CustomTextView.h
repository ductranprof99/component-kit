//
//  CustomTextView.h
//  CKTest
//
//  Created by ductd on 24/9/25.
//

#import <ComponentKit/ComponentKit.h>
#import <ComponentKit/CKStatefulViewComponent.h>
#import <ComponentKit/CKStatefulViewComponentController.h>

@interface CustomTextView : CKStatefulViewComponent
+ (CKComponent *)newWithTextAttribute:(const CKLabelAttributes &)attributes
                                   size:(const CKComponentSize &)size
                              lineLimit:(int)numberOfLimitLine;
@end

@interface CustomTextViewState: NSObject

@property (nonatomic, assign) BOOL hasCalculated;
@property (nonatomic, assign) NSInteger calcId;
@property (nonatomic, assign) CGFloat measuredHeight;

+ (instancetype) newWithExpanded: (BOOL) expanded;
- (BOOL) getIsExpand;
@end


#pragma mark - Controller
@interface CustomTextViewController : CKStatefulViewComponentController
@end
