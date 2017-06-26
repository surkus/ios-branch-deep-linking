//
//  BNCContentDiscoveryManifest.h
//  Branch-TestBed
//
//  Created by Edward Smith on 6/23/17.
//  Copyright © 2017 Branch Metrics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNCContentItem.h"

@interface BNCContentDiscoveryManifest : NSObject

@property (nonatomic, strong) NSString *referredLink;
@property (nonatomic, assign) NSInteger manifestVersion;
@property (nonatomic, assign) NSInteger maxPacketBytes;
@property (nonatomic, assign) NSInteger maxDiscoveryPaths;
@property (nonatomic, assign) NSInteger maxValueLength;
@property (nonatomic, assign) NSTimeInterval discoveryInterval;
@property (nonatomic, assign) BOOL hashContent;
@property (nonatomic, strong) NSArray<NSString*> *contentKeys;
@property (nonatomic, strong) NSArray<NSString*> *contentPaths;
@property (nonatomic, strong) NSArray<NSString*> *contentValues;
@property (nonatomic, assign) BOOL enableScrollWatch;
@property (nonatomic, assign) NSInteger maxDiscoveryRepeat;

@end
