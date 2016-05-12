//
//  LXDProgressView.m
//  LXDProgressView
//
//  Created by 林欣达 on 15/11/17.
//  Copyright © 2015年 sindri lin. All rights reserved.
//

#import "LXDProgressView.h"

@implementation LXDProgressView

- (instancetype)initWithFrame: (CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        self.progressLayer = [LXDProgressLayer layer];
        self.progressLayer.fillColor = [UIColor orangeColor].CGColor;
        self.progressLayer.strokeColor = [UIColor blueColor].CGColor;
        self.progressLayer.frame = self.bounds;
        self.progressLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer: self.progressLayer];
    }
    return self;
}


@end
