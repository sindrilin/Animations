//
//  LXDGroup.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/5/3.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDGroup.h"

@interface LXDGroup ()

@property (nonatomic, strong) dispatch_group_t executeGroup;

@end


@implementation LXDGroup

- (instancetype)init
{
    if (self = [super init]) {
        self.executeGroup = dispatch_group_create();
    }
    return self;
}

- (void)wait
{
    dispatch_group_wait(self.executeGroup, DISPATCH_TIME_FOREVER);
}

- (void)enter
{
    dispatch_group_enter(self.executeGroup);
}

- (void)leave
{
    dispatch_group_leave(self.executeGroup);
}

- (BOOL)wait: (NSTimeInterval)delay
{
    return dispatch_group_wait(self.executeGroup, delay * NSEC_PER_SEC) == 0;
}

@end
