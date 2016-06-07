//
//  LXDQueue.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/4/29.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDQueue.h"
#import "LXDGroup.h"
#import "LXDSemaphore.h"

static LXDQueue * mainQueue;
static LXDQueue * lowPriorityQueue;
static LXDQueue * highPriorityQueue;
static LXDQueue * defaultPriorityQueue;
static LXDQueue * backgroundPriorityQueue;

@interface LXDQueue ()

@property (nonatomic, strong) dispatch_queue_t executeQueue;

@end


@implementation LXDQueue


#pragma mark - 获取线程
+ (instancetype)mainQueue
{
    return mainQueue;
}

+ (instancetype)lowPriorityQueue
{
    return lowPriorityQueue;
}

+ (instancetype)highPriorityQueue
{
    return highPriorityQueue;
}

+ (instancetype)defaultPriorityQueue
{
    return defaultPriorityQueue;
}

+ (instancetype)backgroundPriorityQueue
{
    return backgroundPriorityQueue;
}

+ (void)initialize
{
    if (self == [LXDQueue self]) {
        mainQueue = [LXDQueue new];
        lowPriorityQueue = [LXDQueue new];
        highPriorityQueue = [LXDQueue new];
        defaultPriorityQueue = [LXDQueue new];
        backgroundPriorityQueue = [LXDQueue new];
        
        mainQueue.executeQueue = dispatch_get_main_queue();
        lowPriorityQueue.executeQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        highPriorityQueue.executeQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        defaultPriorityQueue.executeQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        backgroundPriorityQueue.executeQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    }
}


#pragma mark - 便利方法
+ (void)executeInMainQueue: (dispatch_block_t)block
{
    NSParameterAssert(block);
    dispatch_async(dispatch_get_main_queue(), block);
}

+ (void)executeInGlobalQueue: (dispatch_block_t)block
{
    NSParameterAssert(block);
    dispatch_async(dispatch_get_global_queue(LXDDefaultPriority, 0), block);
}

+ (void)executeInGlobalQueue: (dispatch_block_t)block queuePriority: (LXDQueuePriority)queuePriority
{
    NSParameterAssert(block);
    dispatch_async(dispatch_get_global_queue(queuePriority, 0), block);
}

+ (void)executeInMainQueue: (dispatch_block_t)block delay: (NSTimeInterval)delay
{
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), block);
}

+ (void)executeInGlobalQueue: (dispatch_block_t)block delay: (NSTimeInterval)delay
{
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_global_queue(LXDDefaultPriority, 0), block);
}

+ (void)executeInGlobalQueue: (dispatch_block_t)block queuePriority: (LXDQueuePriority)queuePriority delay: (NSTimeInterval)delay
{
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_global_queue(queuePriority, 0), block);
}


#pragma mark - 创建线程
- (instancetype)init
{
    return [self initSerial];
}

- (instancetype)initSerial
{
    if (self = [super init]) {
        self.executeQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (instancetype)initSerialWithIdentifier: (NSString *)identifier
{
    if (self = [super init]) {
        self.executeQueue = dispatch_queue_create(identifier.UTF8String, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (instancetype)initConcurrent
{
    if (self = [super init]) {
        self.executeQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (instancetype)initConcurrentWithIdentifier: (NSString *)identifier
{
    if (self = [super init]) {
        self.executeQueue = dispatch_queue_create(identifier.UTF8String, DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}


#pragma mark - 任务
- (void)execute: (dispatch_block_t)block
{
    NSParameterAssert(block);
    dispatch_async(self.executeQueue, block);
}

- (void)execute: (dispatch_block_t)block delay: (NSTimeInterval)delay
{
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), self.executeQueue, block);
}

- (void)execute: (dispatch_block_t)block wait: (LXDSemaphore *)semaphore
{
    NSParameterAssert(block);
    dispatch_block_t executeBlock = ^{
        [semaphore wait];
        block();
        [semaphore signal];
    };
    dispatch_async(self.executeQueue, executeBlock);
}

- (void)execute: (dispatch_block_t)block delay: (NSTimeInterval)delay wait: (LXDSemaphore *)semaphore
{
    NSParameterAssert(block);
    dispatch_block_t executeBlock = ^{
        [semaphore wait];
        block();
        [semaphore signal];
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), self.executeQueue, executeBlock);
}

- (void)resume
{
    dispatch_resume(self.executeQueue);
}

- (void)suspend
{
    dispatch_suspend(self.executeQueue);
}

- (void)barrierExecute: (dispatch_block_t)block
{
    NSParameterAssert(block);
    dispatch_barrier_async(self.executeQueue, block);
}


#pragma mark - 其他操作
- (void)execute: (dispatch_block_t)block inGroup: (LXDGroup *)group
{
    NSParameterAssert(block);
    dispatch_group_async(group.executeGroup, self.executeQueue, block);
}

- (void)notify: (dispatch_block_t)block inGroup: (LXDGroup *)group
{
    NSParameterAssert(block);
    dispatch_group_notify(group.executeGroup, self.executeQueue, block);
}


@end
