//
//  LXDTimer.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/5/4.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LXDQueue;
/*!
 *  @brief 封装GCD定时器
 */
@interface LXDTimer : NSObject

@property (nonatomic, readonly, strong) dispatch_source_t executeSource;

#pragma mark - 构造器
- (instancetype)initWithExecuteQueue: (LXDQueue *)queue;

#pragma mark - 操作
- (void)execute: (dispatch_block_t)block interval: (NSTimeInterval)interval;
- (void)execute: (dispatch_block_t)block interval: (NSTimeInterval)interval delay: (NSTimeInterval)delay;
- (void)start;
- (void)destory;

@end
