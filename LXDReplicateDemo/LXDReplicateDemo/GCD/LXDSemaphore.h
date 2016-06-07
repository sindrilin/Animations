//
//  LXDSemaphore.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/5/3.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @brief 封装GCD信号量
 */
@interface LXDSemaphore : NSObject

@property (nonatomic, readonly, strong) dispatch_semaphore_t executeSemaphore;

#pragma mark - 构造器
- (instancetype)initWithValue: (NSUInteger)value;

#pragma mark - 操作
- (void)wait;
- (BOOL)waitWithTimeout: (NSTimeInterval)timeout;
- (BOOL)signal;

@end
