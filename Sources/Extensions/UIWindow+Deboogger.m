//
// Copyright (c) 2019 Rosberry. All rights reserved.
//

#import <objc/runtime.h>
#import "UIWindow+Deboogger.h"

@implementation UIWindow(Deboogger)

+ (void)swizzleMethodWithOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    BOOL didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethodWithOriginalSelector:@selector(initWithFrame:)
                               swizzledSelector:@selector(swizzled_initWithFrame:)];
        [self swizzleMethodWithOriginalSelector:@selector(initWithCoder:)
                               swizzledSelector:@selector(swizzled_initWithCoder:)];
    });
}

@end
