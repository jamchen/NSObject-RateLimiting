//
//  NSObject+RateLimiting.m
//  FaceChat
//
//  Created by Andy Hin on 2/21/16.
//  Copyright © 2016 Cory. All rights reserved.
//

#import "NSObject+RateLimiting.h"
#import <objc/runtime.h>



@implementation NSObject (RateLimiting)

const char *THROTTLE_DATA_KEY = "THROTTLE_DATA_KEY";

- (NSMutableDictionary *)getThrottleData {
    NSMutableDictionary *throttleData = objc_getAssociatedObject(self, THROTTLE_DATA_KEY);
    
    if(!throttleData) {
        throttleData = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, THROTTLE_DATA_KEY, throttleData, OBJC_ASSOCIATION_RETAIN);
    }
    
    return throttleData;
}

- (void)throttle:(nonnull SEL)action withObject:(nullable id)object duration:(NSTimeInterval)duration {
    NSMutableDictionary *throttleData = [self getThrottleData];

    NSTimeInterval lastCalled = [[throttleData objectForKey:NSStringFromSelector(action)] timeInterval];
    NSTimeInterval now = [[NSDate date] timeIntervalSinceNow];
    
    if(!lastCalled || (now - duration) >= lastCalled) {
        [throttleData setObject:@([[NSDate date] timeIntervalSinceNow]) forKey:NSStringFromSelector(action)];
        [self performSelector:action withObject:object afterDelay:0.0f];
    }
}

- (void)debounce:(nonnull SEL)action withObject:(nullable id)object duration:(NSTimeInterval)duration {
    __weak typeof(self) weakSelf = self;
    [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:action object:object];
    [weakSelf performSelector:action withObject:object afterDelay:duration];
}

@end
