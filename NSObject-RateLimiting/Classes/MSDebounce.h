//
//  MSDebounce.h
//  Pods
//
//  Created by James Chen on 10/11/2016.
//
//

#import <Foundation/Foundation.h>

@protocol MSCancelable <NSObject>

- (void)cancel;

@end

@interface MSDebounce : NSObject<MSCancelable>
- (nonnull id) init __attribute__((unavailable("Please use one of designated initializers instead.")));
- (nonnull instancetype)initWithTarget:(nonnull id)aTarget selector:(nonnull SEL)aSelector delay:(NSTimeInterval)delay NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithDelay:(NSTimeInterval)delay NS_DESIGNATED_INITIALIZER;
- (void)debounceWithObject:(nullable id)anArgument;
- (void)debounceWithBlock:(nonnull void (^)(void))block;
@end
