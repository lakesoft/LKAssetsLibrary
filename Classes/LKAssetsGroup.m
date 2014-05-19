//
//  AssetsGroup.m
//  SlideshowFun
//
//  Created by Hiroshi Hashiguchi on 2013/07/27.
//  Copyright (c) 2013年 Lakesoft. All rights reserved.
//

#import "LKAssetsGroup.h"
#import "LKAsset.h"
#import "LKAssetsDayGroup.h"

/*
#pragma mark -
#pragma mark NUMutableArray Extension
@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end
@implementation NSMutableArray (Shuffling)

- (void)shuffle
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}
@end
*/

@interface LKAssetsGroup()
@property (strong, nonatomic) ALAssetsGroup* assetsGroup;
@property (strong, nonatomic) NSArray* assets;
@property (strong, nonatomic) NSArray* filteredAssets;
@property (strong, nonatomic) NSMutableArray* dayAssets;
@property (assign, nonatomic) LKAssetsGroupSubFilter subFilter;

// private
@property (strong, nonatomic) NSMutableArray* temporaryAssets;
@end


typedef BOOL (^SubFilterBlock)(LKAsset* asset);

@implementation LKAssetsGroup

#pragma mark -
#pragma makr Privates
- (SubFilterBlock)_subFilterBlock
{
    BOOL (^block)(LKAsset* asset) = nil;
    
    switch (self.subFilter) {
        case LKAssetsGroupSubFilterPhoto:
            block = ^(LKAsset* asset) { return asset.isPhoto; };
            break;
            
        case LKAssetsGroupSubFilterVideo:
            block = ^(LKAsset* asset) { return asset.isVideo; };
            break;
            
        case LKAssetsGroupSubFilterJPEG:
            block = ^(LKAsset* asset) { return asset.isJPEG; };
            break;
            
        case LKAssetsGroupSubFilterPNG:
            block = ^(LKAsset* asset) { return asset.isPNG; };
            break;
            
        case LKAssetsGroupSubFilterScreenShot:
            block = ^(LKAsset* asset) { return asset.isScreenshot; };
            break;
            
        default:
            break;
    }

    return block;
}

- (void)_applySubFilter
{
    if (self.subFilter) {
        NSMutableArray* assets = @[].mutableCopy;
        SubFilterBlock block = [self _subFilterBlock];

        for (LKAsset* asset in self.assets) {
            if (block(asset)) {
                [assets addObject:asset];
            }
        }
        self.filteredAssets = assets;
        [self _setupDayAssetsFromAssets:self.filteredAssets];

    } else {
        self.filteredAssets = nil;
        [self _setupDayAssetsFromAssets:self.assets];
    }
    
}

- (void)_setupDayAssetsFromAssets:(NSArray*)assets
{
    self.dayAssets = @[].mutableCopy;
    LKAssetsDayGroup* dayGroup = nil;
    NSInteger yyyymmdd = -1;

    for (LKAsset* asset in assets) {
        if (asset.yyyymmdd != yyyymmdd) {
            yyyymmdd = asset.yyyymmdd;
            dayGroup = [[LKAssetsDayGroup alloc] initWithYYYYMMMDD:yyyymmdd];
            [self.dayAssets addObject:dayGroup];
        }
        [dayGroup addAsset:asset];
    }
}


#pragma mark -
#pragma mark Basics
- (id)initWithAssetsGroup:(ALAssetsGroup*)assetsGroup groupFilter:(LKAssetsGroupFilter)groupFilter
{
    self = super.init;
    if (self) {
        self.assetsGroup = assetsGroup;
        ALAssetsFilter* assetFilter;
        switch (groupFilter) {
            case LKAssetsGroupFilterAllPhotos:
                assetFilter = ALAssetsFilter.allPhotos;
                break;

            case LKAssetsGroupFilterAllVideos:
                assetFilter = ALAssetsFilter.allVideos;
                break;

            default:
                assetFilter = ALAssetsFilter.allAssets;
                break;
        }
        [self.assetsGroup setAssetsFilter:assetFilter];
    }
    return self;
}


#pragma mark -
#pragma mark Properites (Attributes)
- (NSString*)name
{
    return [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
}
- (UIImage*)posterImage
{
//    if (self.assets.count) {
//        LKAsset* asset = self.assets[self.assets.count-1];
//        return asset.fullScreenImage;
//    } else {
        return [UIImage imageWithCGImage:self.assetsGroup.posterImage];
//    }
}



#pragma mark -
#pragma mark Properites (Assets)
- (NSURL*)url
{
    return [self.assetsGroup valueForProperty:ALAssetsGroupPropertyURL];
}
- (NSUInteger)type
{
    return ((NSNumber*)[self.assetsGroup valueForProperty:ALAssetsGroupPropertyType]).unsignedIntegerValue;
}


#pragma mark -
#pragma mark APIs
+ (LKAssetsGroup*)assetsGroupFrom:(ALAssetsGroup*)assetsGroup groupFilter:(LKAssetsGroupFilter)filter
{
    return [[self alloc] initWithAssetsGroup:assetsGroup groupFilter:filter];
}

- (void)reload
{
    __weak __typeof__(self) _weak_self = self;
    self.temporaryAssets = @[].mutableCopy;

    [_weak_self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            LKAsset* asset = [LKAsset assetFrom:result];
            [self.temporaryAssets addObject:asset];
        } else {
            // completed
            self.assets = [self.temporaryAssets sortedArrayUsingSelector:@selector(compare:)];
            self.temporaryAssets = nil;
            
            [self _applySubFilter];
        }
    }];
}

#pragma mark - API (Types)
- (BOOL)isLibrary
{
    return (self.type & ALAssetsGroupLibrary);
}
- (BOOL)isAlbum
{
    return (self.type & ALAssetsGroupAlbum);
}
- (BOOL)isEvent
{
    return (self.type & ALAssetsGroupEvent);
}
- (BOOL)isFaces
{
    return (self.type & ALAssetsGroupFaces);
}
- (BOOL)isSavedPhoto
{
    return (self.type & ALAssetsGroupSavedPhotos);
}
- (BOOL)isPhotoStream
{
    return (self.type & ALAssetsGroupPhotoStream);
}

#pragma mark - API (Filter)
- (void)applySubFilter:(LKAssetsGroupSubFilter)subFilter
{
    _subFilter = subFilter;
    [self _applySubFilter];
}

- (void)clearSubFilter
{
    [self applySubFilter:LKAssetsGroupSubFilterNo];
}


#pragma mark - API (Day Group)
- (NSInteger)numberOfAssets
{
    return self.filteredAssets ? self.filteredAssets.count : self.assets.count;
}

- (LKAssetsDayGroup*)assetAtIndex:(NSInteger)index
{
    return self.filteredAssets ? self.filteredAssets[index] : self.assets[index];
}


#pragma mark - API (Day Group)
- (NSInteger)numberOfAssetDayGroups
{
    return self.dayAssets.count;
}

- (LKAssetsDayGroup*)assetDayGroupAtIndex:(NSInteger)index
{
    return self.dayAssets[index];
}


#pragma mark -
#pragma mark Overriden
- (NSString*)description
{
    return self.name;
}

@end
