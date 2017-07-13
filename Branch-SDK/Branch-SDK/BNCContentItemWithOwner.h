//
//  BNCContentItemWithOwner.h
//  Branch-SDK
//
//  Created by Edward Smith on 6/20/17.
//  Copyright © 2017 Branch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BRNContentItemWithOwner : NSObject

+ (BRNContentItemWithOwner*) itemForObject:(id<NSObject>)object;
- (NSString*) itemName;
- (NSString*) itemValue;
- (BRNContentItemWithOwner*) superOwner;

@end
