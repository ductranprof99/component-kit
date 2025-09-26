//
//  UserPostCell.m
//  CKTest
//
//  Created by ductd on 23/9/25.
//

#import "UserPostCell.h"
#import "CKComponent_Ext.h"
#import "UIColor+Hex.h"
#import "CustomTextView.h"
#import "ComponentKitViewViewModel.h"

@implementation UserPostCell
+ (instancetype)newWithModel:(CellModel *)model
{
    CKComponent *userAvatar = [
        CustomNetworkImageView
        newWithURL: model.userAvatarURL
        placeholder: nil
        size: {
            .width = CKRelativeDimension::Points(50),
            .height = CKRelativeDimension::Points(50)
        }
        attributes: {
            
        }
        maskType: CustomImageMaskTypeRounded
        radius: 25
    ];
    
    CKComponent *userInfo = [
        CKStackLayoutComponent
        newWithView: { }
        size: {
            .width = CKRelativeDimension::Percent(1),
            .height = CKRelativeDimension::Percent(1)
        }
        style: {
            .direction = CKStackLayoutDirectionVertical,
            .spacing = CGFloat(5),
        }
        children: {
            {
                [
                    CKLabelComponent
                    newWithLabelAttributes: {
                        .string = model.userName,
                        .font = [UIFont
                                 systemFontOfSize:14
                                 weight: 1],
                            .color = [UIColor whiteColor]
                    }
                    viewAttributes:{
                        {@selector(setBackgroundColor:), [UIColor clearColor]}
                    }
                    size:{ }
                ]
            },
            {
                [
                    CKLabelComponent
                    newWithLabelAttributes: {
                        .string = [model.postedDate stringDisplayToCurrent],
                        .font = [UIFont
                                 systemFontOfSize:12
                                 weight: 0.2],
                            .color = [UIColor lightGrayColor]
                    }
                    viewAttributes:{
                        {@selector(setBackgroundColor:), [UIColor clearColor]}
                    }
                    size:{ }
                ]
            }
        }
    ];
    
    CKComponent *userSection = [
        CKStackLayoutComponent
        newWithView: { }
        size: {
            .width = CKRelativeDimension::Percent(1),
            .height = CKRelativeDimension::Points(50)
        }
        style: {
            .direction = CKStackLayoutDirectionHorizontal,
            .spacing = CGFloat(10),
        }
        children: {
            {
                userAvatar
            },
            {
                userInfo
            }
        }
    ];
    
    
    std::vector<CKStackLayoutComponentChild> children;
    children.reserve(3);
    // Append text if present (non-empty after trimming)
    if ([model.postText isKindOfClass:[NSString class]]) {
        NSString *trimmed = [model.postText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (trimmed.length > 0) {
            CKComponent *t = [
                CustomTextView
                newWithTextAttribute: {
                    .string = model.postText,
                    .font = [
                        UIFont
                        systemFontOfSize:14
                        weight: 0.2
                    ],
                        .color = [UIColor whiteColor]
                }
                size:{
                    .width = CKRelativeDimension::Percent(1),
                    .height = CKRelativeDimension::Auto(),
                }
            ];
            
            children.push_back({ .component = t });
        }
    }
    
    
    CKComponent *additionLayout = nil;
    if (model.userPostType == UserPostTypeNormal) {
        if ([model.listImageURL count] != 0) {
            additionLayout = [UserNormalPostSection newWithModel:model];
        }
    } else if (model.userPostType == UserPostTypeVideo) {
        additionLayout = [UserVideoPostSection newWithModel:model];
    } else { // Repost
        additionLayout = [UserRepostSection newWithModel:model];
    }
    
    if (additionLayout) {
        children.push_back({
            .component = additionLayout
        });
    }
    
    CKComponent * bodySection = [
        CKStackLayoutComponent
        newWithView: { }
        size: {
            .width = CKRelativeDimension::Percent(1),
            .height = CKRelativeDimension::Auto()
        }
        style: {
            .direction = CKStackLayoutDirectionVertical,
            .spacing = CGFloat(10),
        }
        children: children
    ];
    
    CKComponent *likeSection = [
        UserPostLikeSection
        newWithModel: model
        likeAction:{
            [ComponentKitViewViewModel sharedInstance],
            @selector(didTapLike:withModel:isLiked:)
        }
        commentAction:{
            [ComponentKitViewViewModel sharedInstance],
            @selector(didTapComment:withModel:)}
    ];
    
    CKComponent *totalCombine = [
        CKStackLayoutComponent
        newWithView: { }
        size: {
            .width = CKRelativeDimension::Percent(1),
            .height = CKRelativeDimension::Auto()
        }
        style: {
            .direction = CKStackLayoutDirectionVertical,
            .spacing = CGFloat(10),
        }
        children: {
            {
                userSection
            },
            {
                bodySection
            },
            {
                likeSection
            }
        }
    ];
    
    
    return [
        super
        newWithComponent: [
            [
                totalCombine
                withPadding:{
                    .top = 10,
                    .bottom = 10,
                    .left = 10,
                    .right = 10
                }
            ]
            withBackgroundColor: [UIColor colorWithHexString: @"242728"]
        ]
    ];
}

@end
