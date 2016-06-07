//
//  LXDSemaphore.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/5/3.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDSemaphore.h"

@interface LXDSemaphore ()

@property (nonatomic, strong) dispatch_semaphore_t executeSemaphore;

@end


@implementation LXDSemaphore

- (instancetype)init
{
    return [self initWithValue: 1];
}

- (instancetype)initWithValue: (NSUInteger)value
{
    if (self = [super init]) {
        self.executeSemaphore = dispatch_semaphore_create(value);
    }
    return self;
}


#pragma mark - 操作
- (void)wait
{
    dispatch_semaphore_wait(self.executeSemaphore, DISPATCH_TIME_FOREVER);
}

- (BOOL)waitWithTimeout: (NSTimeInterval)timeout
{
    return dispatch_semaphore_wait(self.executeSemaphore, dispatch_time(DISPATCH_TIME_NOW, timeout * NSEC_PER_SEC)) == 0;
}

- (BOOL)signal
{
    return dispatch_semaphore_signal(self.executeSemaphore) != 0;
}


@end
