//
//  AssetsGroup.m
//  SlideshowFun
//
//  Created by Hiroshi Hashiguchi on 2013/07/27.
//  Copyright (c) 2013年 Lakesoft. All rights reserved.
//

#import "LKAssetsGroup.h"
#import "LKAsset.h"

NSString* const LKAssetsGroupDidReloadNotification = @"LKAssetsGroupDidReloadNotification";

@interface LKAssetsGroup()
@property (strong, nonatomic) ALAssetsGroup* assetsGroup;
@property (strong, nonatomic) NSArray* assets;

// private
@property (strong, nonatomic) NSMutableArray* temporaryAssets;
@end

@implementation LKAssetsGroup

#pragma mark - Basics
- (id)initWithAssetsGroup:(ALAssetsGroup*)assetsGroup
{
    self = super.init;
    if (self) {
        self.assetsGroup = assetsGroup;
    }
    return self;
}

- (NSString*)description
{
    return self.name;
}


#pragma mark - Properites (Attributes)
- (NSString*)name
{
    return [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
}

- (UIImage*)posterImage
{
    return [UIImage imageWithCGImage:self.assetsGroup.posterImage];
}


#pragma mark - Properites (Assets)
- (NSURL*)url
{
    return [self.assetsGroup valueForProperty:ALAssetsGroupPropertyURL];
}
- (NSUInteger)type
{
    return ((NSNumber*)[self.assetsGroup valueForProperty:ALAssetsGroupPropertyType]).unsignedIntegerValue;
}


#pragma mark - API
+ (LKAssetsGroup*)assetsGroupFrom:(ALAssetsGroup*)assetsGroup
{
    return [[self alloc] initWithAssetsGroup:assetsGroup];
}

- (void)reloadAssets
{
    __weak __typeof__(self) _weak_self = self;
    self.temporaryAssets = @[].mutableCopy;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_weak_self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                LKAsset* asset = [LKAsset assetFrom:result];
                [_weak_self.temporaryAssets addObject:asset];
            } else {
                // completed
                _weak_self.assets = [_weak_self.temporaryAssets sortedArrayUsingSelector:@selector(compare:)];
                _weak_self.temporaryAssets = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [NSNotificationCenter.defaultCenter postNotificationName:LKAssetsGroupDidReloadNotification
                                                                      object:_weak_self];
                });
            }
        }];
    });
}

- (void)unloadAssets
{
    self.assets = nil;
}

@end
