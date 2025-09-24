//
//  UserPostCell.h
//  CKTest
//
//  Created by ductd on 23/9/25.
//

#import <ComponentKit/ComponentKit.h>
#import "CellModel.h"
#import "CustomNetworkImageView.h"
#import "NSDate_Ext.h"

@interface UserPostCell : CKCompositeComponent
+ (instancetype)newWithModel: (CellModel *)model;
@end
