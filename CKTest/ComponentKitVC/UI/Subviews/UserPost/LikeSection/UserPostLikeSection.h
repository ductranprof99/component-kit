//
//  UserPostLikeSection.h
//  CKTest
//
//  Created by ductd on 25/9/25.
//


#import <ComponentKit/ComponentKit.h>
#import "CellModel.h"
#import "CustomNetworkImageView.h"
#import "NSDate_Ext.h"
#import "CKComponent_Ext.h"
#import "UIColor+Hex.h"

@interface UserPostLikeSection : CKCompositeComponent

+ (instancetype)newWithModel: (CellModel *)model
                  likeAction: (const CKTypedComponentAction<CellModel *, BOOL> &)likeAction
               commentAction: (const CKTypedComponentAction<CellModel *> &) commentAction;

+ (CKComponent *) likeButtonLayoutWithModel: (CellModel *)model;
+ (CKComponent *) commentButtonLayoutWithModel: (CellModel *)model;
+ (CKComponent *) paddingWithCornerRadiusWithComponent: (CKComponent *) component;
- (void) didTapLike;
- (void) didTapComment;
@end
