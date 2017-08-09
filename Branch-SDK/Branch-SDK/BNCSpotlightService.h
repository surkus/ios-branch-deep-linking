//
//  BNCSpotlightService.h
//  Branch-TestBed
//
//  Created by edward on 8/9/17.
//  Copyright © 2017 Branch Metrics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BranchUniversalObject.h"

@interface BNCSpotlightService : NSObject

+ (instancetype) sharedService;

- (void) indexObjectOnSpotlight:(BranchUniversalObject*)universalObject
                     completion:(void (^) (BranchUniversalObject*universalObject, NSError *error))completion;

/*!
 param universalObjects     An array of BranchUniversalObject content items that will be indexed.
 param completion           The `completion` block is called once after all items have been indexed or failed.
 param failureHandler       The `failureHandler` is called once per BranchUniversalObject that fails to index.
*/
- (void) indexObjectsOnSpotlight:(NSArray<BranchUniversalObject*>*)universalObjects
                      completion:(void (^) (NSArray<BranchUniversalObject*>*universalObjects))completion
                  failureHandler:(void (^) (BranchUniversalObject*universalObject, NSError *error))failureHandler;

@end

/*
  TODO
  ----
  1. Add a 'spotlightURL' field to the BUO.
     - Add a short URL if public.
     - Add a dynamic URL if private.
  2. If publicly indexible, then publish with NSUserActivity (Limited number of items. How many?)
  3. If private then index publish with CS searchable items (Unlimited number of items.)
  4. Move all spotlight code to this class.
  5. Clean up the old fashioned selector checking to use 'respondsToSelector:'.
  6. Remove BranchCSSearchableItemAttributeSet from project.

  Next (Maybe... Depending on response)
  ----
  1. Download & list thumbnail images if image not already local.
  2. Add a short URL if public.
  3. Add access to a CSSearchableItem property to set weird non-standard attributes not handled by Branch.
  
  Questions
  ---------
  1. Search domain?  Use Branch domain or the App domain?
  2. What about changing objects?
     - Maybe the spotlightURL should be the spotlightIdentifier, which is a URL?
     

*/
