//
//  ListShortCell.h
//  CKTest
//
//  Created by Duc Tran  on 21/9/25.
//

#import "ListShortCell.h"
#import <UIKit/UIKit.h>
#import "AppImageDownloader.h"
#import "CustomScrollView.h"
#import "ShortItemComponent.h"


@implementation ListShortCell
+ (id)initialState {
    return [[ListShortCellModel alloc] initWithItems: @[]];
}


+ (instancetype)newWithData:(CellModel *)model {
    NSArray<NSString *> *shorts = [model.listShortURL isKindOfClass:[NSArray class]] ? model.listShortURL : @[];
    
    NSMutableArray<ListShortCellShortItem *> *result = [NSMutableArray arrayWithCapacity:shorts.count + 1];
    [result addObject:
         [
             ListShortCellShortItem
             addItemWithUsername:model.userName
             withAvatar:model.userAvatarURL
         ]
    ];
    for (NSString *i in shorts) {
        [result addObject: [ListShortCellShortItem urlItem:i]];
    }
    
    CKComponentScope scope(self, model.uuidString, ^id{
        return [[ListShortCellModel alloc] initWithItems: result.copy];
    });
    
    const ListShortCellModel *state = scope.state();
    
    std::vector<CKStackLayoutComponentChild> children;
    children.reserve(shorts.count);
    for (ListShortCellShortItem *s in [state getListShort]) {
        CKComponent *item = [ShortItemComponent newWithItem:s];
        children.push_back({ .component = item });
    }
    
    // Horizontal row of shorts
    CKComponent *row = [
        CKStackLayoutComponent
        newWithView:{}
        size:{}
        style:{
            .direction = CKStackLayoutDirectionHorizontal,
            .spacing = 1,
            .alignItems = CKStackLayoutAlignItemsCenter,
        }
        children:children];
    
    // Wrap in a horizontal CustomScrollView (SwiftUI List-equivalent)
    CKComponent *scrollable = [
        CustomScrollView
        newWithSize:{
            .width = CKRelativeDimension::Percent(1),
            .height = CKRelativeDimension::Auto(),
            .minHeight = 160,
            .maxHeight = 260
        }
        axis:CSVScrollAxisHorizontal
        contentInsets:UIEdgeInsetsMake(0, 12, 0, 12)
        showsVerticalScrollIndicator:NO
        showsHorizontalScrollIndicator:NO
        bounces:YES
        content:row
        onScroll:{}
    ];
    
    CKComponent *padding = [
        CKInsetComponent
        newWithInsets:{
            
        }
        component: [
            CKStackLayoutComponent
            newWithView:{}
            size:{}
            style:{
                .direction = CKStackLayoutDirectionVertical,
                .spacing = 10,
                .alignItems = CKStackLayoutAlignItemsCenter,
            }
            children: {
                {
                    [
                        CKLabelComponent
                        newWithLabelAttributes: {
                            .string = @"Khoảnh khắc",
                            .font = [UIFont systemFontOfSize:14 weight: UIFontWeightBold],
                            .color = [UIColor whiteColor]
                        }
                        viewAttributes:{ }
                        size:{ }
                    ]
                },
                {
                    
                }
            }
        ]
    ];
    
    return [super newWithComponent:padding];
}

- (void)didTap:(UITapGestureRecognizer *)gr {
   
}

@end

@implementation ListShortCellController
- (void)didMount {
    [super didMount];
}

- (void)didRemount {
    [super didRemount];
}

- (void)didUnmount {
    // Cleanup before the view goes away
    [super didUnmount];
}

@end
