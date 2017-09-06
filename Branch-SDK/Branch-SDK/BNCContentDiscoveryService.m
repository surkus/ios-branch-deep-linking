//
//  BNCContentDiscoveryService.m
//  Branch-SDK
//
//  Created by Edward Smith on 6/23/17.
//  Copyright © 2017 Branch Metrics. All rights reserved.
//

#import "BNCContentDiscoveryService.h"
#import "BNCLog.h"

@interface BNCContentDiscoveryService ()
@property (strong, nonatomic) dispatch_source_t discoveryTimerSource;
@property (strong, nonatomic) BNCContentDiscoveryManifest *manifest;
@property (assign, nonatomic) BOOL isStarted;
@end

@implementation BNCContentDiscoveryService

+ (BNCContentDiscoveryService*) sharedInstance {
    static BNCContentDiscoveryService* _sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[BNCContentDiscoveryService alloc] init];
    });
    return _sharedInstance;
}

- (void) startWithManifest:(BNCContentDiscoveryManifest*)manifest {
    @synchronized (self) {
        self.manifest = manifest;
        [self start];
    }
}

- (void) start {
    @synchronized (self) {
        if (self.isStarted) return;
        self.isStarted = YES;

        if (self.manifest.enableScrollWatch) {

            [[NSNotificationCenter defaultCenter]
                addObserver:self
                selector:@selector(contentUpdatedNotification:)
                name:@"UIViewAnimationDidStopNotification"
                object:nil];

        } else if (self.self.manifest.discoveryInterval > 0.0) {

            self.discoveryTimerSource = dispatch_source_create(
                DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue()
            );
            if (!self.discoveryTimerSource) {
                BNCLogError(@"Create discovery timer failed.");
                return;
            }
            dispatch_source_set_event_handler(self.discoveryTimerSource, ^{
                [self discoverContentWithReason:@"Timer"];
            });
            dispatch_source_set_timer(
                self.discoveryTimerSource,
                dispatch_time(DISPATCH_TIME_NOW, self.manifest.discoveryInterval * (double) NSEC_PER_SEC),
                self.manifest.discoveryInterval * (double) NSEC_PER_SEC,
                (1ull * NSEC_PER_SEC) / 10
            );

        }
        
    }
}

- (void) stop {
    @synchronized (self) {
        if (!self.isStarted) return;
        self.isStarted = NO;
        if (self.discoveryTimerSource) {
            dispatch_source_cancel(self.discoveryTimerSource);
            self.discoveryTimerSource = nil;
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void) contentUpdatedNotification:(NSNotification*)notification {
    [self discoverContentWithReason:notification.name];
}

- (void) discoverContentWithReason:(NSString*)reason {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    [self discoverContentForView:window withReason:reason];
}

- (void) discoverContentForView:(UIView*)view withReason:(NSString*)reason {
    NSDate *startDate = [NSDate date];
    BNCLogDebugSDK(@"Scrape reason %@ start %@ view %@.", reason, startDate, view);

    NSArray<BNCContentItem*> *contentArray = [BNCContentItem contentForBaseView:view];
    for (BNCContentItem *item in contentArray) {
        BNCLogDebugSDK(@"%@: %@", item.path, item.value);
    }

    BNCLogDebugSDK(@"Scrape reason %@ elapsed: %1.3fs view %@.",
        reason, - [startDate timeIntervalSinceNow], view);
}

@end
