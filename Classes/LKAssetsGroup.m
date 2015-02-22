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

#pragma mark - Privates
- (void)_assetsLibrarychanged:(NSNotification*)notification
{
    if (self.assets) {
        [self unloadAssets];
        [self reloadAssets];
    }
}

#pragma mark - Basics
- (id)initWithAssetsGroup:(ALAssetsGroup*)assetsGroup
{
    self = super.init;
    if (self) {
        self.assetsGroup = assetsGroup;
        self.assetClass = LKAsset.class;
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(_assetsLibrarychanged:)
                                                   name:ALAssetsLibraryChangedNotification
                                                 object:nil];
    }
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@, %zdpics", self.name, self.numberOfAssets];
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (NSComparisonResult)compare:(LKAssetsGroup*)assetsGroup
{
    return [self.name compare:assetsGroup.name];
}

- (BOOL)isEqual:(LKAssetsGroup*)assetsGroup
{
    if (assetsGroup == self) {
        return YES;
    }
    if (!assetsGroup || ![assetsGroup isKindOfClass:self.class]) {
        return NO;
    }
    return [self.url isEqual:assetsGroup.url];
}

- (NSUInteger)hash
{
    return [self.url hash];
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

- (NSInteger)numberOfAssets
{
    if (self.assets) {
        return self.assets.count;
    }
    return self.assetsGroup.numberOfAssets;
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
                LKAsset* asset = [self.assetClass assetFrom:result];
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
