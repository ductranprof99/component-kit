//
//  UserPostLikeSection.mm
//  CKTest
//
//  Created by ductd on 25/9/25.
//


#import "UserPostLikeSection.h"

@implementation UserPostLikeSection {
    CKTypedComponentAction<CellModel *, BOOL> likeAction;
    CKTypedComponentAction<CellModel *> commentAction;
    CellModel *model;
}
+ (instancetype)newWithModel: (CellModel *)model
                  likeAction: (const CKTypedComponentAction<CellModel *, BOOL> &)likeAction
               commentAction: (const CKTypedComponentAction<CellModel *> &) commentAction
{
    CKComponent *likeButton = [
        CKOverlayLayoutComponent
        newWithComponent: [
            UserPostLikeSection
            itemOnStack: [
                UserPostLikeSection
                likeButtonLayoutWithModel:model
            ]
        ]
        overlay: [
            CKComponent
            newWithView: {
                [UIView class],
                {
                    {CKComponentTapGestureAttribute(@selector(didTapLike))}
                }
            } size: { }
        ]
    ];
    
    CKComponent *commentButton = [
        CKOverlayLayoutComponent
        newWithComponent: [
            UserPostLikeSection
            itemOnStack: [
                UserPostLikeSection
                commentButtonLayoutWithModel:model
            ]
        ]
        overlay: [
            CKComponent
            newWithView: {
                [UIView class],
                {
                    {CKComponentTapGestureAttribute(@selector(didTapComment))}
                }
            } size: { }
        ]
    ];
    
    CKComponent *totalCombine = [
        CKStackLayoutComponent
        newWithView:{}
        size:{}
        style:{
            .direction = CKStackLayoutDirectionHorizontal,
            .spacing = 10
        }
        children:{
            { likeButton },
            { commentButton }
        }
    ];
    
    auto c = [
        super
        newWithComponent:totalCombine
    ];
    c -> likeAction = likeAction;
    c -> commentAction = commentAction;
    c -> model = model;
    return c;
}


- (void)didTapLike {
    likeAction.send(self, model, !model.isLiked);
}

- (void)didTapComment {
    commentAction.send(self, model);
}


+ (CKComponent *) commentButtonLayoutWithModel: (CellModel *)model {
    UIImage *icon = [UIImage systemImageNamed:@"text.bubble"];
    
    CKComponent *head = [
        CKImageComponent
        newWithImage:icon
        attributes:{
            {@selector(setTintColor:), [UIColor whiteColor]}
        }
        size:{
            .width = CKRelativeDimension::Points(20),
            .height = CKRelativeDimension::Points(20),
        }
    ];
    
    CKComponent *tail = nil;
    if (model.comments.count > 0) {
        tail = [
            CKLabelComponent
            newWithLabelAttributes:{
                .string = [NSString stringWithFormat:@"%lu", static_cast<unsigned long>(model.comments.count ?: 0)],
                .font = [UIFont systemFontOfSize:14],
                .color = [UIColor lightGrayColor]
            }
            viewAttributes:{
                {@selector(setBackgroundColor:), [UIColor clearColor]}
            }
            size:{}
        ];
    }
    
    return [
        CKStackLayoutComponent
        newWithView:{}
        size:{}
        style:{
            .direction = CKStackLayoutDirectionHorizontal,
            .spacing = 10
        }
        children:{
            { head },
            { tail }
        }
    ];
}


+ (CKComponent *) likeButtonLayoutWithModel: (CellModel *)model {
    UIImage *base = model.isLiked ? [UIImage imageNamed:@"heart.filled"] : [UIImage imageNamed:@"heart"];
    UIImage *icon = [base imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    CKComponent *head = [
        CKImageComponent
        newWithImage:icon
        attributes:{
            {@selector(setTintColor:), model.isLiked ? [UIColor redColor] : [UIColor whiteColor]}
        }
        size:{
            .width = CKRelativeDimension::Points(20),
            .height = CKRelativeDimension::Points(20),
        }
    ];

    CKComponent *tail = nil;

    if (!model.isLiked) {
        tail = [
            CKLabelComponent
            newWithLabelAttributes:{
                .string = @"Thích",
                .font = [UIFont systemFontOfSize:14],
                .color = [UIColor lightGrayColor]
            }
            viewAttributes:{
                {@selector(setBackgroundColor:), [UIColor clearColor]}
            }
            size:{}
        ];
    } else {
        tail = [
            CKLabelComponent
            newWithLabelAttributes:{
                .string = [NSString stringWithFormat:@"%@", model.likeCount ?: @0],
                .font = [UIFont systemFontOfSize:14],
                .color = [UIColor lightGrayColor]
            }
            viewAttributes:{
                {@selector(setBackgroundColor:), [UIColor clearColor]}
            }
            size:{}
        ];
    }

    return [
        CKStackLayoutComponent
        newWithView:{}
        size:{}
        style:{
            .direction = CKStackLayoutDirectionHorizontal,
            .spacing = 10
        }
        children:{
            { head },
            { tail },
        }
    ];
}

+ (CKComponent *) itemOnStack: (CKComponent *) component {
    return
    [
        [
            [
                component
                withPadding:{
                    .top = 5,
                    .bottom = 5,
                    .left = 15,
                    .right = 15
                }
            ]
            withBackgroundColor: [UIColor colorWithHexString: @"2E2E2E"]
        ]
        cornerRaidus: 15
    ];
}
@end
