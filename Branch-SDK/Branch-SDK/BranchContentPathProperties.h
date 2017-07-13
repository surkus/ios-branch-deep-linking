//
//  ContentPathProperties.h
//  Branch-SDK
//
//  Created by Sojan P.R. on 8/19/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BranchContentPathProperties : NSObject

@property (strong, nonatomic) NSDictionary *pathInfo;
@property (nonatomic) BOOL isClearText;

- (instancetype)init:(NSDictionary *)pathInfo;
- (NSArray *)getFilteredElements;
- (BOOL)isSkipContentDiscovery;
- (BOOL)isClearText;

@end
