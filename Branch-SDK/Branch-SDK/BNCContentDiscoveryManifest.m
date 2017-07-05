//
//  BNCContentDiscoveryManifest.m
//  Branch-TestBed
//
//  Created by Edward Smith on 6/23/17.
//  Copyright © 2017 Branch Metrics. All rights reserved.
//

#import "BNCContentDiscoveryManifest.h"
#import "BNCLog.h"

@implementation BNCContentDiscoveryManifest

- (instancetype) init {
    self = [super init];
    if (!self) return self;

    _manifestScrapeVersion = 0;
    _maxPacketBytes = 10240;
    _maxDiscoveryPaths = 5;
    _maxValueLength = 250;
    _discoveryInterval = 0.500f;
    _hashContent = NO;
    _enableScrollWatch = NO;
    _maxDiscoveryRepeat = 15;

    return self;
}

- (void) setDiscoveryInterval:(NSTimeInterval)discoveryInterval {
    if (discoveryInterval < 0.500) {
        discoveryInterval = 0.500;
    }
    _discoveryInterval = discoveryInterval;
}

+ (instancetype) manifestFromDictionary:(NSDictionary*)dictionary {
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    BNCContentDiscoveryManifest *manifest = [[BNCContentDiscoveryManifest alloc] init];

    #define fObject(x)  x
    #define fInteger(x) [(NSNumber*)x integerValue]
    #define fDouble(x)  [(NSNumber*)x doubleValue]

    #define field(ivar, type, name, access) { \
        id value = dictionary[name]; \
        if ([value isKindOfClass:[type class]]) { \
            manifest.ivar = access(value); \
        } else { \
            BNCLogWarning(@"Invalid type in manifest: '%@' of type '%@'.", \
                name, NSStringFromClass(value)); \
        } \
    }

    field(referredLink, NSString, @"rl", fObject);
    field(manifestScrapeVersion, NSNumber, @"mv", fInteger);
    field(maxPacketBytes, NSNumber, @"mps", fInteger);
    field(maxDiscoveryPaths, NSNumber, @"mhl", fInteger);
    field(maxValueLength, NSNumber, @"mtl", fInteger);
    field(discoveryInterval, NSNumber, @"dri", fDouble);
    field(hashContent, NSNumber, @"h", fInteger);
    field(contentKeys, NSArray, @"ck", fObject);
    field(contentPaths, NSArray, @"cp", fObject);
    field(contentValues, NSArray, @"cd", fObject);
    field(enableScrollWatch, NSNumber, @"branch_ews", fInteger);
    field(maxDiscoveryRepeat, NSNumber, @"mdr", fInteger);

    #undef field
    #undef fObject
    #undef fInteger
    #undef fDouble

    return manifest;
}

- (NSDictionary*) dictionary {

    NSMutableDictionary *dictionary = [NSMutableDictionary new];

    #define fObject(x)  x
    #define fInteger(x) [NSNumber numberWithInteger:x]
    #define fDouble(x)  [NSNumber numberWithDouble:x]

    #define field(ivar, type, name, access) { \
        if (self.ivar) { \
            dictionary[name] = access(self.ivar); \
        } \
    }

    field(referredLink, NSString, @"rl", fObject);
    field(manifestVersion, NSNumber, @"mv", fInteger);
    field(maxPacketBytes, NSNumber, @"mps", fInteger);
    field(maxDiscoveryPaths, NSNumber, @"mhl", fInteger);
    field(maxValueLength, NSNumber, @"mtl", fInteger);
    field(discoveryInterval, NSNumber, @"dri", fDouble);
    field(hashContent, NSNumber, @"h", fInteger);
    field(contentKeys, NSArray, @"ck", fObject);
    field(contentPaths, NSArray, @"cp", fObject);
    field(contentValues, NSArray, @"cd", fObject);
    field(enableScrollWatch, NSNumber, @"branch_ews", fInteger);
    field(maxDiscoveryRepeat, NSNumber, @"mdr", fInteger);
    field(discoveryMode, NSNumber, @"d1", fInteger);

    #undef field
    #undef fObject
    #undef fInteger
    #undef fDouble

    return dictionary;
}

@end
