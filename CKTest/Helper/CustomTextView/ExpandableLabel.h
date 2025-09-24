//
//  ExpandableLabel.h
//  CKTest
//
//  Created by ductd on 24/9/25.
//

#import <UIKit/UIKit.h>

#pragma mark - ExpandableLabel
@interface ExpandableLabel : UILabel

{
    CGFloat defaultHeight;
    CGFloat defaultWidth;
}

@property (nonatomic, assign) CGFloat defaultHeight;
@property (nonatomic, assign) CGFloat defaultWidth;

+(instancetype)sharedLabel;
-(float)getExpandedHeight;
-(float)getExpandedWidth;
-(void)autoExpandHeight;
-(void)autoExpandWidth;

@end
