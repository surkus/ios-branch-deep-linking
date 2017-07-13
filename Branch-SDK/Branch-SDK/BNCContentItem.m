//
//  BNCContentItem.m
//  Branch-SDK
//
//  Created by Edward Smith on 6/20/17.
//  Copyright © 2017 Branch. All rights reserved.
//

#import "BNCContentItem.h"
#import "BNCContentItemWithOwner.h"
#import "UIView+Branch.h"
#import "BNCLog.h"

#pragma mark - 

@implementation BNCContentItem

+ (NSArray<BNCContentItem*>*) contentForBaseView:(UIView*)view {
    NSMutableArray<BNCContentItem*>*resultArray = [NSMutableArray new];
    [view bnc_performBlockOnSubviews:^(UIView *subview) {
        BNCContentItem* item = [self contentStringByOwnerForView:subview];
        if (item) [resultArray addObject:item];
    }];
    return resultArray;
}

+ (BNCContentItem*) contentStringByOwnerForView:(UIView*)subview {
    if (subview.subviews.count > 0) return nil;

    BRNContentItemWithOwner *owner = [BRNContentItemWithOwner itemForObject:subview];
    NSString *name  = [owner itemName];
    NSString *itemValue = [owner itemValue];
    if (!name) {
        BNCLogDebug(@"No name!");   // TODO: remove this debugging code
        name = @"(null)";
    }

    NSMutableArray<NSString*> *nameStack = [NSMutableArray new];
    [nameStack addObject:name];

    owner = [owner superOwner];
    while (owner) {
        name = [owner itemName];
        if (name.length) [nameStack addObject:name];
        owner = [owner superOwner];
    }

    NSMutableString *longName = [NSMutableString new];
    for (name in nameStack.reverseObjectEnumerator) {
        [longName appendFormat:@".%@", name];
    }

    if (longName.length > 0) {
        [longName deleteCharactersInRange:NSMakeRange(0, 1)];
    }

    BNCContentItem *item = [[BNCContentItem alloc] init];
    item.path = longName;
    item.value = itemValue;
    return item;
}

@end
