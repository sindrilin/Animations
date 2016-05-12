//
//  LXDCommonViewController.m
//  LXDSlideMenuObjectiveC
//
//  Created by linxinda on 15/11/29.
//  Copyright © 2015年 sindriLin. All rights reserved.
//

#import "LXDCommonViewController.h"
#import "LXDSlideManager.h"

@interface LXDCommonViewController ()

@end

@implementation LXDCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)clickView:(id)sender {
    [[LXDSlideManager sharedManager] openOrClose];
}

@end
