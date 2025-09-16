//
//  Data.c
//  CKTest
//
//  Created by ductd on 11/9/25.
//

#import <Foundation/Foundation.h>
#import "CellModelType.h"
#import "CellModel.h"
#import <UIKit/UIKit.h>

#pragma mark - Helper

static UIImage *CKCreateSolidImage(CGFloat width, CGFloat height, UIColor *color) {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), YES, 0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, width, height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

static UIColor *ColorFromName(NSString *name) {
    if ([name isEqualToString:@"red"]) {
        return [UIColor redColor];
    }
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    }
    if ([name isEqualToString:@"green"]) {
        return [UIColor greenColor];
    }
    return [UIColor whiteColor];
}



#pragma mark - Cell Model initialie
CellModel *CellModelFromDict(NSDictionary *dict) {
    CellModel *model = [CellModel new];
    NSNumber *typeNum = dict[@"type"];
    if (typeNum) {
        model.cellType = (CellModelType)[typeNum integerValue];
    }
    switch (model.cellType) {
        case CellModelTypeText:
            model.cellType = CellModelTypeText;
            model.text = dict[@"text"];
            break;
        case CellModelTypeVideo:
            model.cellType = CellModelTypeVideo;
            model.videoURL = dict[@"videoURL"];
            break;
        case CellModelTypeImageStrip:
        {
            model.cellType = CellModelTypeImageStrip;
            model.imageURLs = dict[@"images"];
        }
            break;
        case CellModelTypeImage:
            model.cellType = CellModelTypeImage;
            model.randomImage = [UIImage imageNamed:dict[@"randomImage"]];
            model.text = dict[@"text"];
            break;
        case CellModelTypeRandom:
            model.cellType = CellModelTypeRandom;
            model.text = @"test";
            NSNumber *h = dict[@"fixedHeight"];
            model.fixedHeight = h ? [h floatValue] : 120.0f;
            NSString *colorVal = dict[@"randomImage"];
            UIColor *colorG = ColorFromName(colorVal);
            model.randomImage = CKCreateSolidImage(40, 40, colorG);
            break;
    }
    
    return model;
    
}

NSArray *cellListData(void)
{
    static NSArray *data;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *mutableData = [NSMutableArray array];
        for (NSInteger i = 0; i < 25; i++) {
            NSInteger type = i % 5;
            NSDictionary *entry = nil;
            switch (type) {
                case 0: // Text
                    entry = @{
                        @"type": @(CellModelTypeText),
                        @"text": [NSString stringWithFormat:@"Sample text entry #%ld", (long)i]
                    };
                    break;
                case 1: // VideoSquare
                    entry = @{
                        @"type": @(CellModelTypeVideo),
                        @"videoURL": [NSString stringWithFormat:@"https://example.com/video%ld.mp4", (long)i]
                    };
                    break;
                case 2: // ImageStri
                    entry = @{
                        @"type": @(CellModelTypeImageStrip),
                        @"images": @[
                            @"https://picsum.photos/200/300",
                            @"https://picsum.photos/200/300",
                            @"https://picsum.photos/200/300",
                            @"https://picsum.photos/200/300",
                            @"https://picsum.photos/200/300",
                        ]
                    };
                    break;
                case 3:
                    entry = @{
                        @"type": @(CellModelTypeImage),
                        @"text" : @"I updated the CellModelTypeImageStrip case so it now iterates through the array of image names from dict[@\"images\"], loads each UIImage using imageNamed:, and assigns the resulting UIImage array to model.images.",
                        @"randomImage": [NSString stringWithFormat:@"image_feed_%ld", (long)i/5]
                    };
                    break;
                case 4: // Random
                    entry = @{
                        @"type": @(CellModelTypeRandom),
                        @"fixedHeight": @(80 + (i * 10) % 180)
                    };
                    break;
            }
            [mutableData addObject:entry];
        }
        data = [mutableData copy];
    });
    return data;
}

@implementation CellModel

@end
