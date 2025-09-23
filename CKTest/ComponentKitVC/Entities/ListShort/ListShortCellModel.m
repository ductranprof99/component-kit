//
//  ListShortCellModel.m
//  CKTest
//
//  Created by ductd on 23/9/25.
//


#import "ListShortCellModel.h"

@implementation ListShortCellModel

+ (instancetype)initWithItems:(NSArray<ListShortCellShortItem *> *)items
{
    ListShortCellModel *ins = [[ListShortCellModel alloc] init];
    ins->_listShort = [items copy];
    return ins;
}

- (void) addShortItemWithURL: (NSString *) vidURL {
    ListShortCellShortItem *item = [ListShortCellShortItem urlItem:vidURL];
    NSMutableArray<ListShortCellShortItem *> *items = [_listShort mutableCopy];
    [items addObject:item];
    _listShort = [items copy];
}

- (NSArray<ListShortCellShortItem *> *)getListShort
{
    return _listShort;
}

@end
