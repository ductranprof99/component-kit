//
//  ListShortCell.h
//  CKTest
//
//  Created by Duc Tran  on 21/9/25.
//



#import <ComponentKit/ComponentKit.h>
#import "CellModel.h"
#import "AppImageDownloader.h"

@class CellModel;
@class CellContext;

@interface ListShortCellState: NSObject
@property (nonatomic, readonly) BOOL isExpand;

- (instancetype)initWithExpaned:(NSInteger)expanded;
@end

@interface ListShortCell : CKCompositeComponent
+ (instancetype) newWithData: (CellModel *) model
                     context: (CellContext *) context;
@end


@interface ListShortCellController : CKComponentController
@end
