//
//  UIImageView+LXDBannerAnimation.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/5/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "UIView+LXDFadeAnimation.h"

#define LXDFADEDURATION 2.
/*!
 *  @brief 图片轮播广告页碎片化动画
 */
@interface UIImageView (LXDBannerAnimation)

/*!
 *  @brief 设置后停止动画
 */
@property (nonatomic, assign) BOOL stop;
/*!
 *  @brief 每次切换图片的动画时长1.5~2.5
 */
@property (nonatomic, assign) NSTimeInterval fadeDuration;
/*!
 *  @brief 轮播图片数组
 */
@property (nonatomic, strong) NSArray * bannerImages;

- (void)fadeBanner;
- (void)fadeBannerWithImages: (NSArray *)images;
- (void)stopBanner;

@end
