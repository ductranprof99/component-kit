//
//  ImageCell.m
//  CKTest
//
//  Created by ductd on 15/9/25.
//

#import "NewStatusCell.h"
#import <UIKit/UIKit.h>
#import "CellModel.h"
#import "AppImageDownloader.h"
#import "NewStatusChipModel.h"
#import "NewStatusChipComponent.h"
#import "UIColor+Hex.h"
#import "AppImageDownloader.h"
#import <vector>
#import "CustomTextView.h"

namespace std {}

@interface NewStatusCellState ()
@property (nonatomic, strong) NSArray<NewStatusChipModel *> *chips;
@end

@implementation NewStatusCellState

- (instancetype)initEmptyValue {
    self = [super init];
    if (self) {
        _text = @"";
        _imageURLs = @[];
        _videoURLs = @[];
        _chips = @[];
    }
    return self;
}

@end


@implementation NewStatusCell
+ (id)initialState {
    return [[NewStatusCellState alloc] initEmptyValue];
}

+ (instancetype)newWithModel:(CellModel *)model {
    CKComponentScope scope(self);
    
    const CKTypedComponentAction<NSString *> onReturn = {scope, @selector(onReturnText:)};
    const CKTypedComponentAction<NSString *> onEndEditing = {scope, @selector(onEndEditingText:)};
    
    CKComponentViewConfiguration backgroundView = {
        [UIView class],
        {{@selector(setBackgroundColor:), [UIColor colorWithHexString:@"242728"]}}
    };
    
    
    const CKTypedComponentAction<NewStatusChipModel *> action = {scope, @selector(didTapChip:)};
//    const CKTypedComponentAction<NewStatusChipModel *> actionNoController = {@selector(didTapChip:)};
    
    
    CKComponent *full = [
        CKStackLayoutComponent
        newWithView: backgroundView
        
        size:{
            .width = CKRelativeDimension::Percent(1),
            .height = CKRelativeDimension::Auto(),
        }
        style:{
            .direction = CKStackLayoutDirectionVertical,
            .spacing= CGFloat(10)
        }
        children:{
            {
                [NewStatusCell topStackWithCellModel:model onReturn:onReturn onEndEditing:onEndEditing]
            },
            {
                [NewStatusCell bottomStackwithAction:action]
            }
        }];
    
    
    return [super newWithComponent:full];
}

+ (CKComponent *)topStackWithCellModel: (CellModel *)model onReturn:(const CKTypedComponentAction<NSString *> &)onReturn onEndEditing:(const CKTypedComponentAction<NSString *> &)onEndEditing {
    CKComponentViewConfiguration invisibleBackground = {
        [UIView class],
        {{@selector(setBackgroundColor:), [UIColor clearColor]}}
    };
    
    NSURL *userAvatarUrl = [NSURL URLWithString:model.userAvatarURL ?: @"https://picsum.photos/50/50?1"];
    
    CKComponent *imgViewAsync = [
        CKNetworkImageComponent
        newWithURL: userAvatarUrl
        imageDownloader: [[AppImageDownloader alloc] init]
        size: {
            .width = CKRelativeDimension::Points(50),
            .height = CKRelativeDimension::Points(50)
        }
        options: {
            
        }
        attributes: {
            {@selector(setContentMode:), @(UIViewContentModeScaleAspectFit)},
            {@selector(setClipsToBounds:), @(YES)},
            {@selector(setUserInteractionEnabled:), @(YES)},
            {CKComponentViewAttribute::LayerAttribute(@selector(setCornerRadius:)), 25},
        }
    ];
    
    CKComponent *imgView = [
        CKInsetComponent newWithInsets:{
            
        } component:imgViewAsync
    ];

//    std::vector<SEL> selectors = {
//      @selector(textFieldDidEndEditing:),
//      @selector(textFieldShouldReturn:)
//    };
//
//    CKComponent *textView = [
//        CKComponent
//        newWithView:{[UITextField class], {
//
//            {@selector(setText:), @"email"},
//            {
//
//                CKComponentDelegateAttribute(@selector(setDelegate:), std::move(selectors))
//            }
//
//        }}
//        size:{
//            .width = CKRelativeDimension::Points(50),
//            .height = CKRelativeDimension::Points(50),
//        }
//    ];
    
    CKComponent *textView = [
        CustomTextView
        newWithPlaceholder: @"k"
        text: @"asdfasdf"
        size: {
            .width = CKRelativeDimension::Points(100),
            .height = CKRelativeDimension::Points(100),
        }
        onReturn:onReturn
        onEndEditing:onEndEditing
    ];
    
    CKComponent *topStack = [
        CKStackLayoutComponent
        newWithView: invisibleBackground
        size: {
            .width = CKRelativeDimension::Auto(),
            .height = CKRelativeDimension::Auto(),
        }
        style: {
            .direction = CKStackLayoutDirectionHorizontal,
            .alignItems = CKStackLayoutAlignItemsStart,
            .spacing = CGFloat(20)
        }
        children: {
            {
                imgView
            },
            {
                textView
            }
        }
    ];
    
    CKComponent *topLayouts = [
        CKInsetComponent
        newWithInsets:{
            .top=15,.left=5,.bottom=5,.right=5
        }
        component: topStack
    ];
    
    return topLayouts;
}

+ (CKComponent *)bottomStackwithAction: (const CKTypedComponentAction<NewStatusChipModel *> &)action {
    CKComponentViewConfiguration invisibleBackground = {
        [UIView class],
        {{@selector(setBackgroundColor:), [UIColor clearColor]}}
    };
    
    NewStatusChipModel *c1 = [[NewStatusChipModel alloc]
                              initWithImage:@"newstatus.photo"
                              text:@"Ảnh"
                              foregroundColor:[UIColor colorWithHexString: @"7CCE8D"]];
    NewStatusChipModel *c2 = [[NewStatusChipModel alloc]
                              initWithImage:@"newstatus.video"
                              text:@"Video"
                              foregroundColor:[UIColor colorWithHexString: @"D44BBE"]];
    NewStatusChipModel *c3 = [[NewStatusChipModel alloc]
                              initWithImage:@"newstatus.file"
                              text:@"File"
                              foregroundColor:[UIColor colorWithHexString: @"316DEB"]];
    
    CKComponent *scopeActionChip = [NewStatusChipComponent
                                    newWithModel:c1
                                    action: action];
    
    CKComponent *discorageActionChip = [NewStatusChipComponent
                                        newWithModel:c2
                                        action: action];
    
    CKComponent *chip3 = [NewStatusChipComponent
                          newWithModel:c3
                          action: action];
    
    CKComponent *bottomList = [
        CKStackLayoutComponent
        newWithView: invisibleBackground
        size:{
            .width = CKRelativeDimension::Percent(1),
            .height = CKRelativeDimension::Points(50),
        }
        style:{
            .direction = CKStackLayoutDirectionHorizontal,
            .alignItems = CKStackLayoutAlignItemsCenter,
            .spacing = CGFloat(8),
            .justifyContent = CKStackLayoutJustifyContentStart
        }
        children:{
            {scopeActionChip},
            {discorageActionChip},
            {chip3},
        }
    ];
    
    CKComponent *bottomStack = [
        CKInsetComponent
        newWithInsets:{
            .top=5,.left=5,.bottom=5,.right=5
        }
        component: bottomList
    ];
    
    return bottomStack;
}


- (void)didTapChip:(NewStatusChipModel *)chip {
    if (![chip isKindOfClass:[NewStatusChipModel class]]) { return; }
    NSLog(@"Chip tapped: %@", chip.text);
    // TODO: forward event to delegate or post notification as needed
}

- (void) onReturnText:(NSString *)returnText {
    NSLog(@"End edit text");
}

- (void) onEndEditingText:(NSString *)returnText {
    NSLog(@"End edit text");
}

@end

@implementation NewStatusCellController
- (void)didMount {
    [super didMount];
    // Setup after the component’s view is mounted
    NSLog(@"Hey hey hey");
}

- (void)didUnmount {
    // Cleanup before the view goes away
    [super didUnmount];
}

- (void)onReturnText:(NSString *)text {
    NSLog(@"[NewStatusCellController] Return: %@", text);
}

- (void)onEndEditingText:(NSString *)text {
    NSLog(@"[NewStatusCellController] EndEditing: %@", text);
}
@end
