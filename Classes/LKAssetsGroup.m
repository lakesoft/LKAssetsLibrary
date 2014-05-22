//
//  AssetsGroup.m
//  SlideshowFun
//
//  Created by Hiroshi Hashiguchi on 2013/07/27.
//  Copyright (c) 2013年 Lakesoft. All rights reserved.
//

#import "LKAssetsGroup.h"
#import "LKAsset.h"
#import "LKAssetsMonthlyCollection.h"
#import "LKAssetsDailyCollection.h"
#import "LKAssetsHourlyCollection.h"
#import "LKAssetsAllCollection.h"

NSString* const LKAssetsGroupDidChangeCategoryNotification = @"LKAssetsGroupDidChangeCategoryNotification";


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
@property (strong, nonatomic) NSArray* originalAssets;
@property (strong, nonatomic) NSArray* categorisedAssets;
@property (strong, nonatomic) NSArray* collections;

// private
@property (strong, nonatomic) NSMutableArray* temporaryAssets;
@end


typedef BOOL (^CategoryFilter)(LKAsset* asset);

@implementation LKAssetsGroup

#pragma mark -
#pragma makr Privates (Category)
- (CategoryFilter)_categoyFilter
{
    BOOL (^block)(LKAsset* asset) = nil;
    
    switch (self.categoryType) {
        case LKAssetsGroupCategoryTypePhoto:
            block = ^(LKAsset* asset) { return asset.isPhoto; };
            break;
            
        case LKAssetsGroupCategoryTypeVideo:
            block = ^(LKAsset* asset) { return asset.isVideo; };
            break;
            
        case LKAssetsGroupCategoryTypeJPEG:
            block = ^(LKAsset* asset) { return asset.isJPEG; };
            break;
            
        case LKAssetsGroupCategoryTypePNG:
            block = ^(LKAsset* asset) { return asset.isPNG; };
            break;
            
        case LKAssetsGroupCategoryTypeScreenShot:
            block = ^(LKAsset* asset) { return asset.isScreenshot; };
            break;
            
        default:
            break;
    }

    return block;
}

- (void)_setupCategorizedAssets
{
    if (self.categoryType) {
        NSMutableArray* assets = @[].mutableCopy;
        CategoryFilter categolyFilter = [self _categoyFilter];

        for (LKAsset* asset in self.originalAssets) {
            if (categolyFilter(asset)) {
                [assets addObject:asset];
            }
        }
        self.categorisedAssets = assets;
    } else {
        self.categorisedAssets = nil;
    }

    [self _setupCollections];

    [NSNotificationCenter.defaultCenter postNotificationName:LKAssetsGroupDidChangeCategoryNotification object:self];
}


#pragma mark -
#pragma makr Privates (Collection)

- (void)_setupCollections
{
    self.collections = [self _collectionsWithType:self.collectionType];
}

- (NSArray*)_collectionsWithFactory:(LKAssetsCollection*(^)(NSInteger dateTimeInteger))factory scale:(NSInteger)scale
{
    NSMutableArray* collections = @[].mutableCopy;
    NSInteger dateTimeInteger = -1;
    LKAssetsCollection* collection =  nil;
    
    for (LKAsset* asset in self.assets) {
        if (dateTimeInteger != asset.dateTimeInteger/scale) {
            dateTimeInteger = asset.dateTimeInteger/scale;
            collection = factory(dateTimeInteger);
            [collections addObject:collection];
        }
        [collection addAsset:asset];
    }
    return collections;
}
- (NSArray*)_collectionsTypeAll
{
    LKAssetsCollection* collection =  [[LKAssetsCollection alloc] initWithDateTimeInteger:0];
    NSArray* collections = @[collection];
    
    for (LKAsset* asset in self.assets) {
        [collection addAsset:asset];
    }
    return collections;
}

- (NSArray*)_collectionsWithType:(LKAssetsCollectionType)collectionType
{
    switch (collectionType) {
        case LKAssetsCollectionTypeMonthly:
            return [self _collectionsWithFactory:^LKAssetsCollection *(NSInteger dateTimeInteger) {
                return [[LKAssetsMonthlyCollection alloc] initWithDateTimeInteger:dateTimeInteger];
            } scale:10000];    // yyyyMMddHH / 10000 = yyyyMM
            
        case LKAssetsCollectionTypeDaily:
            return [self _collectionsWithFactory:^LKAssetsCollection *(NSInteger dateTimeInteger) {
                return [[LKAssetsDailyCollection alloc] initWithDateTimeInteger:dateTimeInteger];
            } scale:100];    // yyyyMMddHH / 100 = yyyyMMdd

        case LKAssetsCollectionTypeHourly:
            return [self _collectionsWithFactory:^LKAssetsCollection *(NSInteger dateTimeInteger) {
                return [[LKAssetsHourlyCollection alloc] initWithDateTimeInteger:dateTimeInteger];
            } scale:1];    // yyyyMMddHH / 1 = yyyyMMddHH
        
        default:
            return self._collectionsTypeAll;
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
            self.originalAssets = [self.temporaryAssets sortedArrayUsingSelector:@selector(compare:)];
            self.temporaryAssets = nil;
            
            [self _setupCategorizedAssets];
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


#pragma mark - API (Category)
- (void)setCategoryType:(LKAssetsGroupCategoryType)categoryType
{
    if (categoryType == _categoryType) {
        return;
    }
    _categoryType = categoryType;
    [self _setupCategorizedAssets];
}

#pragma mark - API (Collection)
- (void)setCollectionType:(LKAssetsCollectionType)collectionType
{
    if (collectionType == _collectionType) {
        return;
    }
    _collectionType = collectionType;
    [self _setupCategorizedAssets];
    [self _setupCollections];
}


#pragma mark - API (Assets)
- (NSArray*)assets
{
    return self.categorisedAssets ? self.categorisedAssets : self.originalAssets;
}


#pragma mark - API ()

//- (NSInteger)indexFromIndexPath:(NSIndexPath*)indexPath assetsSubGroupsType:(LKAssetsCollectionType)collectionType
//{
//    NSInteger index = 0;
//   
//    NSArray* assetsSubGroups = [self assetsCollectionArrayWithType:collectionType];
//
//    for (NSInteger section = 0; section < indexPath.section; section++) {
//        LKAssetsCollection* assetsSubGroup = assetsSubGroups[section];
//         index += assetsSubGroup.numberOfAssets;
//    }
//    index += indexPath.row;
//    
//    return index;
//}



#pragma mark -
#pragma mark Overriden
- (NSString*)description
{
    return self.name;
}

@end
