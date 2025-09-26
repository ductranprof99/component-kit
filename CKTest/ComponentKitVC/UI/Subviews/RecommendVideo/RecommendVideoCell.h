//
//  RecommendVideoCell.h
//  CKTest
//
//  Created by ductd on 15/9/25.
//

#import <ComponentKit/ComponentKit.h>
#import <UIKit/UIKit.h>
#import "CellModel.h"
#import "AppImageDownloader.h"
#import "CellModel.h"
#import "CellContext.h"


// New type of declaration
@interface RecommendVideoCell : CKCompositeComponent
+ (instancetype)newWithModel:(CellModel *)model;
@end

@interface RecommendVideoCellController: CKComponentController
@end


@interface RecommendVideoCellState: NSObject
@property (nonatomic, readonly) BOOL isExpand;

- (instancetype)initWithExpaned:(NSInteger)expanded;
@end
