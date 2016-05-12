//
//  UIView+LXDFadeAnimation.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/5/10.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LXDMAXDURATION 1.2
#define LXDMINDURATION .2
#define LXDMULTIPLED .25

/*!
 *  @brief UIView的方块渐变隐藏动画
 */
@interface UIView (LXDFadeAnimation)

/*!
 *  @brief 视图是否隐藏
 */
@property (nonatomic, assign, readonly) BOOL isFade;
/*!
 *  @brief 是否处在动画中
 */
@property (nonatomic, assign, readonly) BOOL isFading;
/*!
 *  @brief 垂直方块个数。默认为3
 */
@property (nonatomic, assign) NSInteger verticalCount;
/*!
 *  @brief 水平方块个数。默认为18
 */
@property (nonatomic, assign) NSInteger horizontalCount;
/*!
 *  @brief 方块动画之间的间隔0.2~1.2。默认0.7
 */
@property (nonatomic, assign) NSTimeInterval intervalDuration;
/*!
 *  @brief 每个方块隐藏的动画时间0.05~0.3，最多为动画时长的25%。默认为0.185
 */
@property (nonatomic, assign) NSTimeInterval fadeAnimationDuration;

- (void)configurateWithVerticalCount: (NSInteger)verticalCount horizontalCount: (NSInteger)horizontalCount interval: (NSTimeInterval)interval duration: (NSTimeInterval)duration;

- (void)reverseWithComplete: (void(^)(void))complete;
- (void)animateFadeWithComplete: (void(^)(void))complete;
- (void)reverseWithoutAnimate;

@end
