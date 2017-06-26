//
//  UIView+Branch.m
//  Branch
//
//  Created by Edward Smith on 5/17/17.
//  Copyright © 2017 Branch. All rights reserved.
//

#import "UIView+Branch.h"

void bnc_initialize_UIView_Branch(void) __attribute__((constructor));
void bnc_initialize_UIView_Branch() {
    // Makes sure the category is loaded at startup.
}

@implementation UIView (Branch)

- (id) bnc_superviewOfKindOfClass:(Class) class {
    UIView *view = self.superview;
    while (view && ![view isKindOfClass:class])
        view = view.superview;
    return view;
}

- (UIViewController *) bnc_viewController {
    if ([self isKindOfClass:[UIViewController class]])
        return (id) self;

    id object = [self nextResponder];
    while (object && object != self && ![object isKindOfClass:[UIViewController class]])
        object = [object nextResponder];

    return ([object isKindOfClass:[UIViewController class]]) ? object : nil;
}

- (void) bnc_performBlockOnSubviews:(void (^) (UIView* subview))block {
	block(self);
	for (UIView* view in self.subviews)
		[view bnc_performBlockOnSubviews:block];
}

@end
