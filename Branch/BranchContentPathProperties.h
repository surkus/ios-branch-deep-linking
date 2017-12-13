//
//  ContentPathProperties.h
//  Branch-TestBed
//
//  Created by Sojan P.R. on 8/19/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//

#if __has_feature(modules)
@import Foundation;
#if TARGET_OS_OSX
@import AppKit;
#else
@import UIKit;
#endif
#else
#import <Foundation/Foundation.h>
#if TARGET_OS_OSX
@import AppKit;
#else
@import UIKit;
#endif
#endif

@interface BranchContentPathProperties : NSObject

@property (strong, nonatomic) NSDictionary *pathInfo;
@property (nonatomic) BOOL isClearText;

- (instancetype)init:(NSDictionary *)pathInfo;
- (NSArray *)getFilteredElements;
- (BOOL)isSkipContentDiscovery;
- (BOOL)isClearText;

@end
