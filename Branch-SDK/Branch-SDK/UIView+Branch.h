//
//  UIView+Branch.h
//  Branch
//
//  Created by Edward Smith on 5/17/17.
//  Copyright © 2017 Branch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Branch)
- (id) bnc_superviewOfKindOfClass:(Class) class;
- (UIViewController *) bnc_viewController;
- (void) bnc_performBlockOnSubviews:(void (^) (UIView* subview))block;
@end
