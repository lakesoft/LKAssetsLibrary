//
//  AssetsGroup.m
//  SlideshowFun
//
//  Created by Hiroshi Hashiguchi on 2013/07/27.
//  Copyright (c) 2013年 Lakesoft. All rights reserved.
//

#import "LKAssetsGroup.h"
#import "LKAsset.h"
#import "LKAssetsSubGroup.h"
#import "LKAssetsMonthlyGroup.h"
#import "LKAssetsDailyGroup.h"
#import "LKAssetsHourlyGroup.h"

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
@property (assign, nonatomic) LKAssetsGroupSubFilter subFilter;

@property (strong, nonatomic) NSMutableArray* monthlyGroups;
@property (strong, nonatomic) NSMutableArray* dailyGroups;
@property (strong, nonatomic) NSMutableArray* hourlyGroups;

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

- (void)_clearSubGroups
{
    self.monthlyGroups = nil;
    self.dailyGroups = nil;
    self.hourlyGroups = nil;
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
    } else {
        self.filteredAssets = nil;
    }

    [self _clearSubGroups];
}

- (NSMutableArray*)_subGroupsWithFactory:(LKAssetsSubGroup*(^)(NSInteger dateTimeInteger))factory scale:(NSInteger)scale
{
    NSArray* assets = self.filteredAssets ? self.filteredAssets : self.assets;
    NSMutableArray* subGroups = @[].mutableCopy;
    NSInteger dateTimeInteger = -1;
    LKAssetsSubGroup* subGroup =  nil;
    
    for (LKAsset* asset in assets) {
        if (dateTimeInteger != asset.dateTimeInteger/scale) {
            dateTimeInteger = asset.dateTimeInteger/scale;
            subGroup = factory(dateTimeInteger);
            [subGroups addObject:subGroup];
        }
        [subGroup addAsset:asset];
    }
    return subGroups;
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
    return [UIImage imageWithCGImage:self.assetsGroup.posterImage];
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


#pragma mark - API (Group)
- (NSInteger)numberOfAssets
{
    return self.filteredAssets ? self.filteredAssets.count : self.assets.count;
}

- (LKAsset*)assetAtIndex:(NSInteger)index
{
    return self.filteredAssets ? self.filteredAssets[index] : self.assets[index];
}


#pragma mark - API (Sub Groups)
- (NSMutableArray*)monthlyGroups
{
    if (_monthlyGroups == nil) {
        _monthlyGroups = [self _subGroupsWithFactory:^LKAssetsSubGroup *(NSInteger dateTimeInteger) {
            return [[LKAssetsMonthlyGroup alloc] initWithDateTimeInteger:dateTimeInteger];
        } scale:10000];    // yyyyMMddHH / 10000 = yyyyMM
    }
    return _monthlyGroups;
}
- (NSArray*)assetsMonthlyGroups
{
    return self.monthlyGroups;
}

- (NSMutableArray*)dailyGroups
{
    if (_dailyGroups == nil) {
        _dailyGroups = [self _subGroupsWithFactory:^LKAssetsSubGroup *(NSInteger dateTimeInteger) {
            return [[LKAssetsDailyGroup alloc] initWithDateTimeInteger:dateTimeInteger];
        } scale:100];    // yyyyMMddHH / 100 = yyyyMMdd
    }
    return _dailyGroups;
}
- (NSArray*)assetsDailyGroups
{
    return self.dailyGroups;
}

- (NSMutableArray*)hourlyGroups
{
    if (_hourlyGroups == nil) {
        _hourlyGroups = [self _subGroupsWithFactory:^LKAssetsSubGroup *(NSInteger dateTimeInteger) {
            return [[LKAssetsHourlyGroup alloc] initWithDateTimeInteger:dateTimeInteger];
        } scale:1];    // yyyyMMddHH / 1 = yyyyMMddHH
    }
    return _hourlyGroups;
}
- (NSArray*)assetsHourlyGroups
{
    return self.hourlyGroups;
}


#pragma mark -
#pragma mark Overriden
- (NSString*)description
{
    return self.name;
}

@end
