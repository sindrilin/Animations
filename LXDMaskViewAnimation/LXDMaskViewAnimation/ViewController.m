//
//  ViewController.m
//  LXDMaskViewAnimation
//
//  Created by 林欣达 on 16/5/10.
//  Copyright © 2016年 CNPay. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+LXDBannerAnimation.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageOne;
@property (strong, nonatomic) IBOutlet UIImageView *imageTwo;
@property (strong, nonatomic) IBOutlet UIImageView *bannerImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self maskViewTest];
//    [self imageFadeTransition];
//    [self bannerFadeAnimate];
}

/*!
 *  @brief maskView测试
 */
- (void)maskViewTest
{
    UIView * viewContainer = [[UIView alloc] initWithFrame: CGRectMake(0, 50, 200, 200)];
    viewContainer.backgroundColor = [UIColor blueColor];
    
    UIView * contentView = [[UIView alloc] initWithFrame: CGRectMake(20, 20, 160, 160)];
    contentView.backgroundColor = [UIColor redColor];
    [viewContainer addSubview: contentView];
    
    UIView * maskView = [[UIView alloc] initWithFrame: CGRectMake(100, 100, 35, 80)];
    maskView.backgroundColor = [UIColor colorWithWhite: 1 alpha: 0.5];
    contentView.maskView = maskView;
    [self.view addSubview: viewContainer];
    maskView.backgroundColor = [UIColor clearColor];
    UIView * sub1 = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 20, 34)];
    sub1.backgroundColor = [UIColor blackColor];
    UIView * sub2 = [[UIView alloc] initWithFrame: CGRectMake(15, 18, 33, 40)];
    sub2.backgroundColor = [UIColor blackColor];
    [maskView addSubview: sub1];
    [maskView addSubview: sub2];
}

/*!
 *  @brief 碎片动画效果
 */
- (void)imageFadeTransition
{
    if (_imageTwo.isFade) {
        [_imageTwo reverseWithComplete: ^{
            NSLog(@"View show again");
        }];
    } else {
        [_imageTwo animateFadeWithComplete: ^{
            NSLog(@"Finished fade animation");
        }];
    }
}

/*!
 *  @brief 广告页轮播效果
 */
- (void)bannerFadeAnimate
{
    NSMutableArray * images = @[].mutableCopy;
    for (NSInteger idx = 1; idx < 5; idx++) {
        [images addObject: [NSString stringWithFormat: @"banner%lu", idx]];
    }
    [_bannerImageView fadeBannerWithImages: images];
}


@end
