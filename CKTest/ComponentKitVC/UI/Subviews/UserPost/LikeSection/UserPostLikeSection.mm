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
            UserPostLikeSection likeButtonLayoutWithModel:model
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
            UserPostLikeSection commentButtonLayoutWithModel:model
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
            .spacing = 20
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
    
    CKComponent *heart = [
        CKImageComponent
        newWithImage:icon
        attributes:{}
        size:{
            .width = CKRelativeDimension::Points(20),
            .height = CKRelativeDimension::Points(20),
        }
    ];
    
    CKComponent *countLabel = nil;
    if (model.comments.count > 0) {
        countLabel = [
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
            { heart },
            { countLabel },
        }
    ];
}


+ (CKComponent *) likeButtonLayoutWithModel: (CellModel *)model {
    UIImage *base = model.isLiked ? [UIImage systemImageNamed:@"heart.fill"] : [UIImage systemImageNamed:@"heart"];
    UIImage *icon = [base imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    CKComponent *heart = [
        CKImageComponent
        newWithImage:icon
        attributes:{}
        size:{
            .width = CKRelativeDimension::Points(20),
            .height = CKRelativeDimension::Points(20),
        }
    ];

    UIColor *tint = model.isLiked ? [UIColor systemRedColor] : [UIColor lightGrayColor];
    CKComponent *tintContainer = [
        CKComponent
        newWithView:{ [UIView class], { { @selector(setTintColor:), tint } } }
        size:{}
    ];

    CKComponent *tintedHeart = [
        CKOverlayLayoutComponent
        newWithComponent:tintContainer
        overlay:heart
    ];

    CKComponent *countLabel = [
        CKLabelComponent
        newWithLabelAttributes:{
            .string = [NSString stringWithFormat:@"%@", model.likeCount ?: @0],
            .font = [UIFont systemFontOfSize:14],
            .color = [UIColor darkTextColor]
        }
        viewAttributes:{
            {@selector(setBackgroundColor:), [UIColor clearColor]}
        }
        size:{}
    ];

    CKComponent *likeLabel = nil;
    if (model.isLiked) {
        likeLabel = [
            CKLabelComponent
            newWithLabelAttributes:{
                .string = @"Thích",
                .font = [UIFont systemFontOfSize:14],
                .color = [UIColor darkTextColor]
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
            { tintedHeart },
            { countLabel },
            { likeLabel }
        }
    ];
}

@end
