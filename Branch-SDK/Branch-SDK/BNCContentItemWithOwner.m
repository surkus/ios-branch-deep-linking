//
//  BNCContentItemWithOwner.m
//  Branch-SDK
//
//  Created by Edward Smith on 6/20/17.
//  Copyright © 2017 Branch. All rights reserved.
//

#import "BNCContentItemWithOwner.h"
#import "UIView+Branch.h"
#import "BNCLog.h"
#import <objc/runtime.h>

@interface BNCDummyClassForSelectorDefinitions : NSObject

// Dummy selectors to fool the compiler when we reference them later.
- (id)af_activeImageDownloadReceipt;
- (nullable NSURL *)sd_imageURL;
- (NSURL*) imageURL;
- (NSURL*) imageUrl;
- (NSURL*) Url;
- (NSURL*) url;
@end

@implementation BNCDummyClassForSelectorDefinitions

- (id)af_activeImageDownloadReceipt {
    return nil;
}

- (nullable NSURL *)sd_imageURL {
    return nil;
}

- (NSURL*) imageURL {
    return nil;
}

- (NSURL*) imageUrl {
    return nil;
}

- (NSURL*) Url {
    return nil;
}

- (NSURL*) url {
    return nil;
}

@end

#pragma mark - BRNContentItemWithOwner

@interface BRNContentItemWithOwner () {
    NSString *_itemValue;
    NSString *_itemName;
}
@property (strong, nonatomic) id<NSObject> owner;
@property (strong, nonatomic) id<NSObject> item;
@property (strong, nonatomic) NSString *ivarName;

@end

#pragma mark BRNContentItemWithOwner

@implementation BRNContentItemWithOwner

+ (BRNContentItemWithOwner *)itemForObject:(id<NSObject>)object {

    BRNContentItemWithOwner *contentOwner = nil;
    if ([object isKindOfClass:[UIResponder class]]) {
        contentOwner = [self ownerForResponder:(UIResponder*)object];
        if (contentOwner) return contentOwner;
    }
    if ([object isKindOfClass:[UIView class]]) {
        contentOwner = [self ownerForView:(UIView *)object];
        if (contentOwner) return contentOwner;
    }
    if ([object isKindOfClass:[UITableViewCell class]]) {
        UITableView *view = [(UITableViewCell*)object bnc_superviewOfKindOfClass:UITableView.class];
        if (view) {
            contentOwner = [BRNContentItemWithOwner new];
            contentOwner.owner = view;
            contentOwner.item = object;
            return contentOwner;
        }
    }
    if ([object isKindOfClass:[UICollectionViewCell class]]) {
        UICollectionView *view = [(UICollectionViewCell*)object bnc_superviewOfKindOfClass:UICollectionView.class];
        if (view) {
            contentOwner = [BRNContentItemWithOwner new];
            contentOwner.owner = view;
            contentOwner.item = object;
            return contentOwner;
        }
    }
    if ([object isKindOfClass:[UIViewController class]]) {
        UIViewController *viewController = (UIViewController*)object;
        UIViewController *parent = nil;
        if (!parent) parent = [viewController presentingViewController];
        if (!parent) parent = [viewController parentViewController];
        //if (!parent) parent = [viewController presentedViewController];
        if (parent) {
            contentOwner = [BRNContentItemWithOwner new];
            contentOwner.owner = parent;
            contentOwner.item = object;
            return contentOwner;
        }
    }
    if ([object isKindOfClass:[UIView class]]) {
        UIResponder *responder = [(UIView*)object nextResponder];
        while (responder && responder != object) {
            if (![responder isKindOfClass:[UIView class]]) {
                contentOwner = [BRNContentItemWithOwner new];
                contentOwner.owner = responder;
                contentOwner.item = object;
                return contentOwner;
            }
            responder = responder.nextResponder;
        }
    }
    return nil;
}

+ (BRNContentItemWithOwner*)ownerForResponder:(UIResponder*)responder {

    UIResponder *nextResponder = responder.nextResponder;
    while (nextResponder && nextResponder != responder) {
        NSString *ivarName = [self ivarNameFromObject:responder fromOwner:nextResponder];
        if (ivarName) {
            BRNContentItemWithOwner *contentOwner = [BRNContentItemWithOwner new];
            contentOwner.item = responder;
            contentOwner.ivarName = ivarName;
            contentOwner.owner = nextResponder;
            return contentOwner;
        }
        nextResponder = nextResponder.nextResponder;
    }
    return nil;
}

+ (BRNContentItemWithOwner*)ownerForView:(UIView *)view {

    BRNContentItemWithOwner *owner = [BRNContentItemWithOwner new];
    owner.item = view;

    NSString *ivarName = nil;
    UIViewController *viewController = [view bnc_viewController];
    ivarName = [self.class ivarNameFromObject:view fromOwner:viewController];
    if (ivarName) {
        owner.owner = viewController;
        owner.ivarName = ivarName;
        return owner;
    }

    UIView *superview = view.superview;
    while (superview) {
        ivarName = [self.class ivarNameFromObject:view fromOwner:superview];
        if (ivarName) {
            owner.owner = superview;
            owner.ivarName = ivarName;
            return owner;
        }

        viewController = [superview bnc_viewController];
        ivarName = [self.class ivarNameFromObject:view fromOwner:viewController];
        if (ivarName) {
            owner.owner = viewController;
            owner.ivarName = ivarName;
            return owner;
        }

        superview = superview.superview;
    }

    return nil;
}

+ (NSString *)ivarNameFromObject:(id)object fromOwner:(id)owner {
    NSString *result = nil;
    if (owner == nil || object == nil) return result;

    Class ownerClass = object_getClass(owner);
    void *objectPtr = (__bridge void *) object;

    uint count = 0;
    Ivar *ivars = class_copyIvarList(ownerClass, &count);
    for (int i = 0; i < count; ++i) {
        const void *ivarPtr = (__bridge void *) object_getIvar(owner, ivars[i]);
        if (ivarPtr == objectPtr) {
            const char *ivarName = ivar_getName(ivars[i]);
            result = [NSString stringWithUTF8String:ivarName];
            break;
        }
    }
    
    if (ivars) free(ivars);
    return result;
}

- (NSString*) itemValue {
    if (_itemValue) return _itemValue;
    _itemValue = [BRNContentItemWithOwner itemValueFromView:_item];
    return _itemValue;
}

- (NSString*) itemName {
    if (_itemName) return _itemName;

    // Find a name:

    NSMutableString *name = [NSMutableString string];
    if (_ivarName) {
        [name appendString:_ivarName];
    } else {
        [name appendString:NSStringFromClass(_item.class)];
    }

    if ([_item isKindOfClass:[UITableViewCell class]]) {

        UITableViewCell *cell = (id) _item;
        UITableView *tableView = [(UIView*)_item bnc_superviewOfKindOfClass:[UITableView class]];
        NSIndexPath *path = [tableView indexPathForCell:cell];
        [name appendFormat:@":%@[%ld:%ld]",
            cell.reuseIdentifier, (long) path.section, (long) path.row];

    } else if ([_item isKindOfClass:[UICollectionViewCell class]]) {

        UICollectionViewCell *cell = (id) _item;
        UICollectionView *collectionView = [(UIView*)_item bnc_superviewOfKindOfClass:[UICollectionView class]];
        NSIndexPath *path = [collectionView indexPathForCell:cell];
        [name appendFormat:@":%@[%ld:%ld]",
            cell.reuseIdentifier, (long) path.section, (long) path.row];
    }

    if ([_item isKindOfClass:UIView.class] && ((UIView*)_item).tag != 0) {
        [name appendFormat:@"(%ld)", (long) ((UIView*)_item).tag];
    }

    _itemName = name;
    return _itemName;
}

- (BRNContentItemWithOwner*) superOwner {
    if (self.owner == nil) return nil;
    BRNContentItemWithOwner *sup = [BRNContentItemWithOwner itemForObject:self.owner];
    if (!sup && self.owner) {
        sup = [BRNContentItemWithOwner new];
        sup.item = self.owner;
    }
    return sup;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"<%@: 0x%lx item: %@ owner: %@ ivar: %@ value: %@>",
        NSStringFromClass(self.class), (unsigned long) self, NSStringFromClass(_item.class),
        NSStringFromClass(_owner.class), _ivarName, _itemValue];
}

+ (NSString *)itemValueFromView:(id<NSObject>)view {
    // Make sure we're really returning a string.

    NSString *string = [self itemValueFromView_raw:view];
    if (!string) return nil;
    
    if ([string isKindOfClass:NSString.class])
        return string;

    if ([string isKindOfClass:NSURL.class])
        return [(NSURL*)string absoluteString];

    if ([string isKindOfClass:NSAttributedString.class])
        return [(NSAttributedString*)string string];

    if ([string isKindOfClass:NSNumber.class])
        return [(NSNumber*)string stringValue];

    return nil;
}

+ (NSString *)itemValueFromView_raw:(id<NSObject>)view {

    if ([view respondsToSelector:@selector(isSecureTextEntry)]) {
        id isSecure = [view performSelector:@selector(isSecureTextEntry)];
        if (isSecure) return @"(secure)";
    }

    #define returnNSStringForSelector(sel) { \
        if ([view respondsToSelector:@selector(sel)]) { \
            NSString *string = [view performSelector:@selector(sel)]; \
            if ([string isKindOfClass:NSString.class] && string.length) \
                return string; \
        } \
    }

    returnNSStringForSelector(text);
    returnNSStringForSelector(attributedText);
    returnNSStringForSelector(placeholder);
    returnNSStringForSelector(attributedPlaceholder);

    #undef returnNSStringForSelector

    if ([view isKindOfClass:[UIImageView class]]) {
        return [self.class imageNameFromImageView:(UIImageView *) view];
    }

    if ([view respondsToSelector:@selector(stringValue)]) {
        return [view performSelector:@selector(stringValue)];
    }

    if ([view respondsToSelector:@selector(value)]) {
        NSNumber *value = [view performSelector:@selector(value)];
        long intValue = (long) (__bridge void*) value;
        // TODO: Fix this dangerous pointer detection.
        if (intValue > (long) 0x00ffff &&
            [value respondsToSelector:@selector(stringValue)]) {
            return [value stringValue];
        } else {
            return [NSString stringWithFormat:@"%ld", intValue];
        }
    }

    return nil;
}

+ (NSString *)imageNameFromImageView:(UIImageView *)imageView {

    // Guess --

    #define returnNSStringForSelector(sel) { \
        if ([imageView respondsToSelector:@selector(sel)]) { \
            NSURL *URL = [imageView performSelector:@selector(sel)]; \
            if ([URL isKindOfClass:[NSURL class]]) { \
                return [URL absoluteString]; \
            } else if ([URL isKindOfClass:[NSString class]]) { \
                return (NSString*) URL; \
            } \
        } \
    }

    returnNSStringForSelector(URL);
    returnNSStringForSelector(Url);
    returnNSStringForSelector(url);
    returnNSStringForSelector(imageURL);
    returnNSStringForSelector(imageUrl);
    returnNSStringForSelector(sd_imageURL); // SDWebImage
    returnNSStringForSelector(name);
    returnNSStringForSelector(title);

    #undef returnNSStringForSelector

    // AFNetwork image view --

    static Class AFImageDownloadReceiptClass = nil;
    if (!AFImageDownloadReceiptClass) {
        AFImageDownloadReceiptClass = NSClassFromString(@"AFImageDownloadReceipt");
    }
    id receipt = objc_getAssociatedObject(self, @selector(af_activeImageDownloadReceipt));
    if (receipt && [receipt isKindOfClass:AFImageDownloadReceiptClass] &&
        [receipt respondsToSelector:@selector(task)]) {
        NSURLSessionDataTask *task = [receipt performSelector:@selector(task)];
        if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
            return [task.currentRequest.URL absoluteString];
        }
    }

    // Debugging: Dump object for discovery. 
    //BNCLogDumpObject(imageView);

    return nil;
}

@end
