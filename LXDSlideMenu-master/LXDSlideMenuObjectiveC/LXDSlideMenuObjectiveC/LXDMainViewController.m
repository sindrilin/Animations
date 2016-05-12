//
//  LXDMainViewController.m
//  LXDSlideMenuObjectiveC
//
//  Created by linxinda on 15/11/29.
//  Copyright © 2015年 sindriLin. All rights reserved.
//

#import "LXDMainViewController.h"
#import "LXDSlideManager.h"

@interface LXDMainViewController ()

@end

@implementation LXDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController * slideController = [[UIStoryboard storyboardWithName: @"Main" bundle: nil] instantiateViewControllerWithIdentifier: @"menuController"];
    LXDSlideManager * slideManager = [LXDSlideManager sharedManager];
    [slideManager setupMainController: self];
    [slideManager setupMenuController: slideController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
