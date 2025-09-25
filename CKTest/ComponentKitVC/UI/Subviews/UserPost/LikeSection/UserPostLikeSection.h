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

@interface UserPostLikeSection : CKCompositeComponent

+ (instancetype)newWithModel: (CellModel *)model
                  likeAction: (const CKTypedComponentAction<BOOL> &)likeAction
               commentAction: (const CKTypedComponentAction<BOOL> &) commentAction;

+ (CKComponent *) likeButtonLayoutWithModel: (CellModel *)model;
+ (CKComponent *) commentButtonLayoutWithModel: (CellModel *)model;
- (void) didTapLike;
- (void) didTapComment;
@end
