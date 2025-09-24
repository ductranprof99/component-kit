//
//  CKComponent_Ext.h
//  CKTest
//
//  Created by ductd on 24/9/25.
//

#import <ComponentKit/ComponentKit.h>


@interface CKComponent (Sizing)
- (instancetype) withPadding: (UIEdgeInsets) inset;
- (instancetype) withBackground: (CKComponent *) background;
- (instancetype) withBackgroundColor: (UIColor *) backgroundColor;
- (instancetype) cornerRaidus: (CGFloat) radius;

@end

