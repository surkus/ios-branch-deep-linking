//
//  BNCContentDiscoveryManifest.h
//  Branch-SDK
//
//  Created by Edward Smith on 6/23/17.
//  Copyright © 2017 Branch Metrics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNCContentItem.h"

typedef NS_ENUM(NSInteger, BNCDiscoveryMode) {
    BNCDiscoveryModeOff         = 0,
    BNCDiscoveryModeDiscover    = 1,
    BNCDiscoveryModeReport      = 2,
};

@interface BNCContentDiscoveryManifest : NSObject

@property (nonatomic, strong) NSString          *referredLink;
@property (nonatomic, assign) NSInteger         manifestScrapeVersion;
@property (nonatomic, assign) NSInteger         maxPacketBytes;
@property (nonatomic, assign) NSInteger         maxDiscoveryPaths;
@property (nonatomic, assign) NSInteger         maxValueLength;
@property (nonatomic, assign) NSTimeInterval    discoveryInterval;
@property (nonatomic, assign) BOOL              hashContent;
@property (nonatomic, strong) NSArray<NSString*> *contentKeys;
@property (nonatomic, strong) NSArray<NSString*> *contentPaths;
@property (nonatomic, strong) NSArray<NSString*> *contentValues;
@property (nonatomic, assign) BOOL              enableScrollWatch;
@property (nonatomic, assign) NSInteger         maxDiscoveryRepeat;
@property (nonatomic, assign) BNCDiscoveryMode  discoveryMode;

+ (instancetype) manifestWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary*) dictionary;
@end
