//
//  UserNormalPostSection.h
//  CKTest
//
//  Created by ductd on 25/9/25.
//


#import <ComponentKit/ComponentKit.h>
#import "CellModel.h"
#import "CustomNetworkImageView.h"
#import "NSDate_Ext.h"

@interface UserNormalPostSection : CKCompositeComponent
+ (instancetype)newWithModel: (CellModel *)model;
@end

