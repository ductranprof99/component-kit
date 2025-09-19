//
//  ChipModel.h
//  CKTest
//
//  Created by ductd on 19/9/25.
//

#import <UIKit/UIKit.h>

// MARK: - Chip model
@interface NewStatusChipModel : NSObject
@property (nonatomic, copy) NSString *imageName;      // name in app asset catalog
@property (nonatomic, strong) UIColor *backgroundColor; // chip background color
@property (nonatomic, copy) NSString *text;           // chip label text
- (instancetype)initWithImage:(NSString *)imageName
                         text:(NSString *)text
               backgroundColor:(UIColor *)backgroundColor;
@end
