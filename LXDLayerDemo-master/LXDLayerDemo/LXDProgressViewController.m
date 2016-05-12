//
//  LXDProgressViewController.m
//  LXDLayerDemo
//
//  Created by linxinda on 15/11/17.
//  Copyright © 2015年 sindriLin. All rights reserved.
//

#import "LXDProgressViewController.h"
#import "LXDProgressView.h"

@interface LXDProgressViewController ()

@property (nonatomic, strong) LXDProgressView * progressView;

@end

@implementation LXDProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _progressView = [[LXDProgressView alloc] initWithFrame: CGRectMake(0, 80, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame))];
    _progressView.progress = 0.f;
    _progressView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview: _progressView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)changeProgress:(UISlider *)sender
{
    self.progressView.progress = sender.value;
}


@end
