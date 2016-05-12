//
//  LXDAnimateButton.h
//  LXDAutoLayoutAnimationDemo
//
//  Created by linxinda on 16/3/17.
//  Copyright © 2016年 sindriLin. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface LXDAnimateButton : UIButton

@property (nonatomic, assign) IBInspectable CGFloat radius;

- (void)start;
- (void)stop;

@end
