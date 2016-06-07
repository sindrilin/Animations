//
//  LXDGroup.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/5/3.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @brief 封装GCD任务组
 */
@interface LXDGroup : NSObject

@property (nonatomic, readonly, strong) dispatch_group_t executeGroup;

#pragma mark - 操作
- (void)wait;
- (void)enter;
- (void)leave;
- (BOOL)wait: (NSTimeInterval)delay;

@end
