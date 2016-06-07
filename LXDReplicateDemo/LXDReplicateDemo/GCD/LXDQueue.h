//
//  LXDQueue.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/4/29.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LXDGroup;
@class LXDSemaphore;

/*!
 *  @brief 线程优先等级
 */
typedef NS_ENUM(NSInteger, LXDQueuePriority) {
    /// 最低优先级
    LXDLowPriority = DISPATCH_QUEUE_PRIORITY_LOW,
    /// 最高优先级
    LXDHighPriority = DISPATCH_QUEUE_PRIORITY_HIGH,
    /// 默认优先级
    LXDDefaultPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT,
    /// 后台优先级
    LXDBackgroundPriority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
};

/*!
 *  @brief 封装GCD队列
 */
@interface LXDQueue : NSObject

@property (nonatomic, readonly, strong) dispatch_queue_t executeQueue;

#pragma mark - 获取线程
+ (instancetype)mainQueue;
+ (instancetype)lowPriorityQueue;
+ (instancetype)highPriorityQueue;
+ (instancetype)defaultPriorityQueue;
+ (instancetype)backgroundPriorityQueue;

#pragma mark - 便利方法
+ (void)executeInMainQueue: (dispatch_block_t)block;
+ (void)executeInGlobalQueue: (dispatch_block_t)block;
+ (void)executeInGlobalQueue: (dispatch_block_t)block queuePriority: (LXDQueuePriority)queuePriority;

+ (void)executeInMainQueue: (dispatch_block_t)block delay: (NSTimeInterval)delay;
+ (void)executeInGlobalQueue: (dispatch_block_t)block delay: (NSTimeInterval)delay;
+ (void)executeInGlobalQueue: (dispatch_block_t)block queuePriority: (LXDQueuePriority)queuePriority delay: (NSTimeInterval)delay;

#pragma mark - 创建线程
- (instancetype)init;
- (instancetype)initSerial;
- (instancetype)initSerialWithIdentifier: (NSString *)identifier;
- (instancetype)initConcurrent;
- (instancetype)initConcurrentWithIdentifier: (NSString *)identifier;

#pragma mark - 操作
- (void)execute: (dispatch_block_t)block;
- (void)execute: (dispatch_block_t)block delay: (NSTimeInterval)delay;
- (void)execute: (dispatch_block_t)block wait: (LXDSemaphore *)semaphore;
- (void)execute: (dispatch_block_t)block delay: (NSTimeInterval)delay wait: (LXDSemaphore *)semaphore;

- (void)resume;
- (void)suspend;
- (void)barrierExecute: (dispatch_block_t)block;

#pragma mark - 其他操作
- (void)notify: (dispatch_block_t)block inGroup: (LXDGroup *)group;
- (void)execute: (dispatch_block_t)block inGroup: (LXDGroup *)group;

@end
