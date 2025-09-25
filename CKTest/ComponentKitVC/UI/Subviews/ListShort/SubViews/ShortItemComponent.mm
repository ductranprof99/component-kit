//
//  ShortItemComponent.m
//  CKTest
//
//  Created by ductd on 22/9/25.
//


//
//  ShortItemComponent.mm
//  CKTest
//

#import "ShortItemComponent.h"

@implementation ShortItemComponent {
    CKTypedComponentAction<ListShortCellShortItem *> _action;
    ListShortCellShortItem *itemModel;
}

+ (instancetype)newWithItem:(ListShortCellShortItem *)item
                     action: (const CKTypedComponentAction<ListShortCellShortItem *> &) action
{
    CKComponentScope scope(self, item.identifier);
    
    if (item.type == ShortItemTypeAdd) {
        NSString *urlString = item.userAvatar;
        NSURL *url = (urlString.length > 0) ? [NSURL URLWithString:urlString] : nil;
        
        CKComponent * padded = [ShortItemComponent imagePartWithURL:url];
        
        auto component = [super newWithComponent:padded];
        component -> _action = action;
        component -> itemModel = item;
        return component;
    } else {
        
        NSString *urlString = item.url;
        NSURL *url = (urlString.length > 0) ? [NSURL URLWithString:urlString] : nil;
        // A simple thumbnail; tune the size to your design
        
        CKComponent * padded = [ShortItemComponent imagePartWithURL:url];
        
        auto component = [super newWithComponent:padded];
        component -> _action = action;
        component -> itemModel = item;
        return component;
    }
}

+ (CKComponent *)imagePartWithURL: (NSURL *)url {
    CKComponent *image = [
        CKNetworkImageComponent
        newWithURL:url
        imageDownloader:[[AppImageDownloader alloc] init]
        size:{
            .width  = CKRelativeDimension::Points(110),
            .height = CKRelativeDimension::Points(180),
            .maxHeight = 220
        }
        options:{}
        attributes:{
            {@selector(setContentMode:), @(UIViewContentModeScaleAspectFill)},
            {@selector(setClipsToBounds:), @(YES)},
            {CKComponentViewAttribute::LayerAttribute(@selector(setCornerRadius:)), @(8.0)}
        }];
    
    CKComponent *padded = [
        CKInsetComponent
        newWithInsets: {
            .top=0,.left=0,.bottom=0,.right=12
        }
        component:image];
    
    CKComponent *overlay = [CKComponent
                            newWithView: {
        [UIView class],
        {CKComponentTapGestureAttribute(@selector(didTap))}
    }
                            size:{
        .width = CKRelativeDimension::Auto(),
        .height = CKRelativeDimension::Auto(),
    }];
    
    CKComponent *totalCombine = [CKOverlayLayoutComponent newWithComponent:padded
                 overlay: overlay
    ];
    
    
    return totalCombine;
}

- (void)didTap {
    _action.send(self, itemModel);
}

@end
