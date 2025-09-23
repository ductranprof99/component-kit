//
//  ListShortCellModel.m
//  CKTest
//
//  Created by ductd on 23/9/25.
//


#import "ListShortCellModel.h"

@implementation ListShortCellModel

- (instancetype)initWithItems:(NSArray<ListShortCellShortItem *> *)items
{
    if ((self = [super init])){
        _listShort = items;
    }
    return self;
}

- (NSArray<ListShortCellShortItem *> *)getListShort
{
    return _listShort;
}

@end
