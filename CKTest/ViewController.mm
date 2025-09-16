//
//  ViewController.m
//  CKTest
//
//  Created by ductd on 10/9/25.
//

#import "ViewController.h"
#import "ComponentKitViewController.h"
#import "CKTest-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumLineSpacing:10];
    [flowLayout setMinimumInteritemSpacing:0];
    
    ComponentKitViewController *cpVC = [
        [ComponentKitViewController alloc]
        initWithCollectionViewLayout: flowLayout];
    cpVC.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"Component Kit"
                                                    image:[UIImage systemImageNamed: @"play.square"]
                                            selectedImage:[UIImage systemImageNamed: @"play.square.fill"]];
    cpVC.view.backgroundColor = UIColor.redColor;
    SwiftUIViewController *cpVC2 = [SwiftUIViewController new];
    cpVC2.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"Component Kit"
                                                    image:[UIImage systemImageNamed: @"fish"]
                                            selectedImage:[UIImage systemImageNamed: @"fish.fill"]];
    
    self.viewControllers = @[cpVC, cpVC2];
}


@end
