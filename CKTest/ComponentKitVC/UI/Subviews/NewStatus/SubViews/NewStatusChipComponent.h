//
//  NewStatusChipComponent 2.h
//  CKTest
//
//  Created by ductd on 19/9/25.
//


#import <ComponentKit/ComponentKit.h>

@class NewStatusChipModel;

@interface NewStatusChipComponent : CKCompositeComponent
+ (instancetype)newWithModel:(NewStatusChipModel *)model
                      action:(const CKTypedComponentAction<NewStatusChipModel *> &)action;
- (void)_handleTap:(CKComponent *)sender;

@end
