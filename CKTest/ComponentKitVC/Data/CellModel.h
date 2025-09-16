//
//  CellModel.h
//  CKTest
//
//  Created by ductd on 11/9/25.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CellModelType.h"

@interface CellModel : NSObject

@property (nonatomic) CellModelType cellType;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSURL *videoURL;
@property (nonatomic) CGFloat fixedHeight;
@property (nonatomic, copy) NSArray<NSString *> *listImageURL;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) UIImage *randomImage;
@property (nonatomic, copy) NSString *reuseKey;
@end
