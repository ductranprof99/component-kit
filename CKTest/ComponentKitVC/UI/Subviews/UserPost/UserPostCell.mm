//
//  UserPostCell.m
//  CKTest
//
//  Created by ductd on 23/9/25.
//

#import "UserPostCell.h"
#import "CKComponent_Ext.h"
#import "CustomTextView.h"

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
            CKComponent *textComponent = [
                    CustomTextView
                    newWithTextAttribute: {
                        .string = @"ádfasdfasdfhjasdjflkasjdlkfjjaskldjflkasjdlfjaskldfjlaksjdfkl;ạdlkfjalksdjfl;kạdflkajsldkfjal;ksdjfl;ạdklfajslkdfjalksjdfl;ạdlfjasldjflasjdflasjdlkfjasl;djflk;ádjlkfjsal;kdfjalksjdfl;kạdlfjasl;kdfjal;ksdjflk;ạdfl;kádlkfjals;djfl;kạdfasđkljfádfasdfasdfhjasdjflkasjdl------kạdlfjasl;kdfjal;ksdjflk;ạdfl;kádlkfjals;djfl;kạdfasđkljf----",
                        .font = [
                            UIFont
                            systemFontOfSize:12
                            weight: 0.2
                        ],
                        .color = [UIColor whiteColor]
                    }
                    size:{
                        .width = CKRelativeDimension::Percent(1),
                        .height = CKRelativeDimension::Auto(),
                    }
                    lineLimit: 3
            ];
            children.push_back({ .component = textComponent });
        }
    }
    
    if (model.userPostType == UserPostTypeNormal) {
        if ([model.listImageURL count] != 0) {
            CKComponent *imageLayout = [
                CKComponent
                newWithView: {
                    [UIView class]
                }
                size:{
                    .width = CKRelativeDimension::Percent(1),
                    .height = CKRelativeDimension::Points(400),
                }
            ];
            
            children.push_back({
                .component = imageLayout
            });
        }
    } else if (model.userPostType == UserPostTypeVideo) {
        
    } else { // Repost
        
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
        CKComponent
        newWithView: {
            [UIView class]
        }
        size:{}
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
        newWithComponent: [totalCombine withPadding:{
            .top = 10,
            .bottom = 10,
            .left = 10,
            .right = 10
        }]
    ];
}

@end
