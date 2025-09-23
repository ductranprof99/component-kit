//
//  ListShortCellModel.h
//  CKTest
//
//  Created by ductd on 23/9/25.
//

#import <Foundation/Foundation.h>
#import "ListShortCellShortItem.h"


@interface ListShortCellModel : NSObject
@property (nonatomic, copy, readonly) NSArray<ListShortCellShortItem *> *listShort;

+ (instancetype)initWithItems:(NSArray<ListShortCellShortItem *> *)items;
- (void) addShortItemWithURL: (NSString *) vidURL;
- (NSArray<ListShortCellShortItem *> *) getListShort;
@end
