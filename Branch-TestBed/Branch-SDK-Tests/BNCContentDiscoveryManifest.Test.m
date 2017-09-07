//
//  BNCContentDiscoveryManifest.Test.m
//  Branch-SDK
//
//  Created by Edward Smith on 9/6/17.
//  Copyright © 2017 Branch Metrics. All rights reserved.
//

#import "BNCTestCase.h"
#import "BNCContentDiscoveryManifest.h"
#import "NSString+Branch.h"

@interface BNCContentDiscoveryManifestTest : BNCTestCase
@end


@implementation BNCContentDiscoveryManifestTest

- (void) testSerialize {
    BNCContentDiscoveryManifest *m = [BNCContentDiscoveryManifest new];
    m.referredLink          = @"https://partner.app.link";
    m.manifestScrapeVersion = 1;
    m.maxPacketBytes        = 2;
    m.maxDiscoveryPaths     = 3;
    m.maxValueLength        = 4;
    m.discoveryInterval     = 5.0;
    m.hashContent           = YES;
    m.contentPaths          = @[ @"p1", @"p2" ];
    m.contentKeys           = @[ @"k1", @"k2" ];
    m.contentValues         = @[ @"v1", @"v2" ];
    m.enableScrollWatch     = YES;
    m.maxDiscoveryRepeat    = 6;
    m.discoveryMode         = BNCDiscoveryModeDiscover;

    NSDictionary *d = m.dictionary;
    BNCContentDiscoveryManifest *n = [BNCContentDiscoveryManifest manifestWithDictionary:d];

    XCTAssertEqualObjects(  m.referredLink,             n.referredLink);
    XCTAssertEqual(         m.manifestScrapeVersion,    n.manifestScrapeVersion);
    XCTAssertEqual(         m.maxPacketBytes,           n.maxPacketBytes);
    XCTAssertEqual(         m.maxDiscoveryPaths,        n.maxDiscoveryPaths);
    XCTAssertEqual(         m.maxValueLength,           n.maxValueLength);
    XCTAssertEqual(         m.discoveryInterval,        n.discoveryInterval);
    XCTAssertEqual(         m.hashContent,              n.hashContent);
    XCTAssertEqualObjects(  m.contentPaths,             n.contentPaths);
    XCTAssertEqualObjects(  m.contentKeys,              n.contentKeys);
    XCTAssertEqualObjects(  m.contentValues,            n.contentValues);
    XCTAssertEqual(         m.enableScrollWatch,        n.enableScrollWatch);
    XCTAssertEqual(         m.maxDiscoveryRepeat,       n.maxDiscoveryRepeat);
    XCTAssertEqual(         m.discoveryMode,            n.discoveryMode);
}

- (void) testDescription {
    BNCContentDiscoveryManifest *m = [BNCContentDiscoveryManifest new];
    m.referredLink          = @"https://partner.app.link";

    NSString *d = m.description;
    XCTAssertTrue(
        [d bnc_isEqualToMaskedString:
    @"<BNCContentDiscoveryManifest 0x**************** url: https://partner.app.link mode: 0 paths: (null)>"]
    );
}

@end
