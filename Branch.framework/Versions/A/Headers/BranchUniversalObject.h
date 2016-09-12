//
//  BranchUniversalObject.h
//  Branch-TestBed
//
//  Created by Derrick Staten on 10/16/15.
//  Copyright © 2015 Branch Metrics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Branch.h"

@class BranchLinkProperties;

typedef void (^shareCompletion) (NSString *_Nonnull activityType, BOOL completed);

typedef NS_ENUM(NSInteger, ContentIndexMode) {
    ContentIndexModePublic,
    ContentIndexModePrivate
};

@interface BranchUniversalObject : NSObject

@property (nonatomic, strong) NSString *canonicalIdentifier;
@property (nonatomic, strong) NSString *canonicalUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *contentDescription;
@property (nonatomic, strong) NSString *imageUrl;
// Note: properties found in metadata will overwrite properties on the BranchUniversalObject itself
@property (nonatomic, strong) NSDictionary *metadata;
@property (nonatomic, strong) NSString *type;
@property (nonatomic) ContentIndexMode contentIndexMode;
@property (nonatomic, strong) NSArray *keywords;
@property (nonatomic, strong) NSDate *expirationDate;
@property (nonatomic, strong) NSString *spotlightIdentifier;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, assign) BOOL automaticallyListOnSpotlight;


- (instancetype)initWithCanonicalIdentifier:(NSString *)canonicalIdentifier;
- (instancetype)initWithTitle:(NSString *)title;

- (void)addMetadataKey:(NSString *)key value:(NSString *)value;

- (void)registerView;
- (void)registerViewWithCallback:(callbackWithParams)callback;

- (void)userCompletedAction:(NSString *)action;

- (NSString *)getShortUrlWithLinkProperties:(BranchLinkProperties *)linkProperties;
- (NSString *)getShortUrlWithLinkPropertiesAndIgnoreFirstClick:(BranchLinkProperties *)linkProperties;
- (void)getShortUrlWithLinkProperties:(BranchLinkProperties *)linkProperties andCallback:(callbackWithUrl)callback;

- (UIActivityItemProvider *)getBranchActivityItemWithLinkProperties:(BranchLinkProperties *)linkProperties;

- (void)showShareSheetWithShareText:(NSString *)shareText completion:(shareCompletion)completion;
- (void)showShareSheetWithLinkProperties:(BranchLinkProperties *)linkProperties andShareText:(NSString *)shareText fromViewController:(UIViewController *)viewController completion:(shareCompletion)completion;
//iPad
- (void)showShareSheetWithLinkProperties:(BranchLinkProperties *)linkProperties andShareText:(NSString *)shareText fromViewController:(UIViewController *)viewController anchor:(UIBarButtonItem *)anchor completion:(shareCompletion)completion;

- (void)listOnSpotlight;
- (void)listOnSpotlightWithCallback:(callbackWithUrl)callback;
- (void)listOnSpotlightWithIdentifierCallback:(callbackWithUrlAndSpotlightIdentifier)spotlightCallback __attribute__((deprecated(("iOS 10 has changed how Spotlight indexing works and we’ve updated the SDK to reflect this. Please see https://dev.branch.io/features/spotlight-indexing/overview/ for instructions on migration"))));;

// Convenience method for initSession methods that return BranchUniversalObject, but can be used safely by anyone.
+ (BranchUniversalObject *)getBranchUniversalObjectFromDictionary:(NSDictionary *)dictionary;

- (NSString *)description;

@end