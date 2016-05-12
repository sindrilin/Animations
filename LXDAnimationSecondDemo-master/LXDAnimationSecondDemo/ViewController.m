//
//  ViewController.m
//  LXDAnimationSecondDemo
//
//  Created by 林欣达 on 16/2/2.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *leaf;           ///<    树叶
@property (strong, nonatomic) IBOutlet UILabel *summer;
@property (strong, nonatomic) IBOutlet UILabel *autumn;
@property (strong, nonatomic) NSTimer * timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    
    /// 把下面的define这行代码注释就可以开启UIView的移动动画
#define KEYFRAMEANIMATION
#ifdef KEYFRAMEANIMATION
    _timer = [NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(drawLeafPath) userInfo: nil repeats: YES];
    
    /// 替换options的参数看不同的效果
    [UIView animateKeyframesWithDuration: 4 delay: 0 options: UIViewKeyframeAnimationOptionCalculationModeCubic animations: ^{
        __block CGPoint center = _leaf.center;
        [UIView addKeyframeWithRelativeStartTime: 0 relativeDuration: 0.1 animations: ^{
            _leaf.center = (CGPoint){ center.x + 15, center.y + 80 };
        }];
        [UIView addKeyframeWithRelativeStartTime: 0.1 relativeDuration: 0.15 animations: ^{
            _leaf.center = (CGPoint){ center.x + 45, center.y + 185 };
        }];
        [UIView addKeyframeWithRelativeStartTime: 0.25 relativeDuration: 0.3 animations: ^{
            _leaf.center = (CGPoint){ center.x + 90, center.y + 295 };
        }];
        [UIView addKeyframeWithRelativeStartTime: 0.55 relativeDuration: 0.3 animations: ^{
            _leaf.center = (CGPoint){ center.x + 180, center.y + 375 };
        }];
        [UIView addKeyframeWithRelativeStartTime: 0.85 relativeDuration: 0.15 animations: ^{
            _leaf.center = (CGPoint){ center.x + 260, center.y + 435 };
        }];
        [UIView addKeyframeWithRelativeStartTime: 0 relativeDuration: 1 animations: ^{
            _leaf.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } completion: ^(BOOL finished) {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
    }];
    
    
#else
    
    [self moveLeafWithOffset: (CGPoint){ 15, 80 } completion: ^(BOOL finished) {
        [self moveLeafWithOffset: (CGPoint){ 30, 105 } completion: ^(BOOL finished) {
            [self moveLeafWithOffset: (CGPoint){ 40, 110 } completion: ^(BOOL finished) {
                [self moveLeafWithOffset: (CGPoint){ 90, 80 } completion: ^(BOOL finished) {
                    [self moveLeafWithOffset: (CGPoint){ 80, 60 } completion: nil duration: 0.6];
                } duration: 1.2];
            } duration: 1.2];
        } duration: 0.6];
    } duration: 0.4];
    
    [UIView animateWithDuration: 4 animations: ^{
        _leaf.transform = CGAffineTransformMakeRotation(M_PI);
    }];
#endif
    
    CGFloat offset = _autumn.frame.size.height / 2;
    _autumn.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 0), CGAffineTransformMakeTranslation(0, -offset));
    CGAffineTransform transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 0.05), CGAffineTransformMakeTranslation(0, offset));
    
    [UIView animateWithDuration: 4 animations: ^{
        _autumn.alpha = 1;
        _summer.alpha = 0;
        _autumn.transform = CGAffineTransformIdentity;
        _summer.transform = transform;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)moveLeafWithOffset: (CGPoint)offset completion: (void(^)(BOOL finished))completion duration: (NSTimeInterval)duration
{
    [UIView animateWithDuration: duration delay: 0 options: UIViewAnimationOptionCurveLinear animations: ^{
        CGPoint center = _leaf.center;
        center.x += offset.x;
        center.y += offset.y;
        _leaf.center = center;
    } completion: completion];
}

- (void)drawLeafPath
{
    UIView * point = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 2, 2)];
    CALayer * layer = _leaf.layer.presentationLayer;
    point.backgroundColor = [UIColor redColor];
    point.center = layer.position;
    [self.view insertSubview: point belowSubview: _leaf];
}


@end
