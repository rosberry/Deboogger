//
// Copyright © 2020 Rosberry. All rights reserved.
//

import ObjectiveC.runtime

func swizzle(_ cls: AnyClass, _ originalSelector: Selector, _ swizzledSelector: Selector) {
    guard let originalMethod = class_getInstanceMethod(cls, originalSelector),
          let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector) else {
        return
    }
    method_exchangeImplementations(originalMethod, swizzledMethod)
}
