//
//  BNCContentItem.h
//  Branch-SDK
//
//  Created by Edward Smith on 6/20/17.
//  Copyright © 2017 Branch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNCContentItem : NSObject

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *value;

+ (NSArray<BNCContentItem*>*) contentForBaseView:(UIView*)view;

@end
