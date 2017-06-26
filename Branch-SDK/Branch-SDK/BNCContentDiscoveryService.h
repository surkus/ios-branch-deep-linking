//
//  BNCContentDiscoveryService.h
//  Branch-TestBed
//
//  Created by Edward Smith on 6/23/17.
//  Copyright © 2017 Branch Metrics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BNCContentDiscoveryManifest.h"

@interface BNCContentDiscoveryService : NSObject
+ (BNCContentDiscoveryService*) sharedInstance;
- (void) startWithManifest:(BNCContentDiscoveryManifest*)manifest;
- (void) stop;
@end
