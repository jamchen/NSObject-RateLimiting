//
//  MSDebounce.m
//  Pods
//
//  Created by James Chen on 10/11/2016.
//
//

#import "MSDebounce.h"

@interface MSDebounce ()

@property (nonatomic, strong) NSInvocation* invocation;
@property (nonatomic, assign) NSTimeInterval delay;
@property (atomic, strong) void (^executionBlock)(void);

@end

@implementation MSDebounce


- (nonnull instancetype)initWithTarget:(id)aTarget selector:(SEL)aSelector delay:(NSTimeInterval)delay
{
    self = [super init];
    if (self) {
        self.invocation = [NSInvocation invocationWithMethodSignature:[aTarget methodSignatureForSelector:aSelector]];
        _invocation.target = aTarget;
        _invocation.selector = aSelector;
        self.delay = delay;
    }
    return self;
}
- (nonnull instancetype)initWithDelay:(NSTimeInterval)delay {
    self = [super init];
    if (self) {
        self.delay = delay;
    }
    return self;
}
- (void)debounceWithObject:(id)anArgument {
    [self cancel];
    [self.invocation setArgument:&anArgument atIndex:2];
    [self performSelector:@selector(debounce) withObject:nil afterDelay:_delay];
}
- (void)debounceWithBlock:(void (^)(void))block {
    [self cancel];
    self.executionBlock = block;
    [self performSelector:@selector(debounce) withObject:nil afterDelay:_delay];
}
- (void)debounce {
    if (_invocation) {
        [self.invocation invoke];
    } else if (_executionBlock) {
        _executionBlock();
    }
}
- (void)cancel {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(debounce) object:nil];
}

@end
