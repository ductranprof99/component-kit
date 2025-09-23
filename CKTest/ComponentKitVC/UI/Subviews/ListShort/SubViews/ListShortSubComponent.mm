//
//  ListShortCell.m
//  CKTest
//
//  Created by ductd on 23/9/25.
//

#import "ListShortSubComponent.h"
#import <UIKit/UIKit.h>
#import "CustomScrollView.h"


@implementation ListShortSubComponent
+ (id)initialState {
    return [ListShortCellModel initWithItems: @[]];
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
        return [ListShortCellModel initWithItems: result.copy];
    });
    
    const ListShortCellModel *state = scope.state();
    
    std::vector<CKStackLayoutComponentChild> children;
    children.reserve(shorts.count);
    for (ListShortCellShortItem *s in [state getListShort]) {
        CKComponent *item = [
            ShortItemComponent
            newWithItem:s
            action: {scope, @selector(didTap:withModel:)}
        
        ];
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
        contentInsets: UIEdgeInsetsZero
        showsVerticalScrollIndicator:NO
        showsHorizontalScrollIndicator:NO
        bounces:YES
        content:row
        onScroll:{}
    ];
    
    return [super newWithComponent:scrollable];
}

- (void)didTap: (ShortItemComponent *) sender
     withModel: (ListShortCellShortItem *) item {
    switch (item.type) {
        case ShortItemTypeAdd:
            [
                self
                updateState: ^(ListShortCellModel *old){
                    [old addShortItemWithURL: @"https://fastly.picsum.photos/id/557/400/300.jpg?hmac=DdhZzMtqhqVPgJCCs_apofp30QFn87JyUIjsd9mzSJc"];
                    return old;
                }
                mode:CKUpdateModeAsynchronous
            ];
            break;
        case ShortItemTypeURL:
            
            break;
    }
}

@end

@implementation ListShortSubComponentController

-(void)didMount {
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
