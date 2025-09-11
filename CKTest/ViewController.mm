//
//  ViewController.m
//  CKTest
//
//  Created by ductd on 10/9/25.
//

#import "ViewController.h"
#import "ComponentKitVC/ComponentKitViewController.h"
#import "CKTest-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ComponentKitViewController *cpVC = [ComponentKitViewController new];
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
