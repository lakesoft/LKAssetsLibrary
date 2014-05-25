//
//  AssetsGroup.m
//  SlideshowFun
//
//  Created by Hiroshi Hashiguchi on 2013/07/27.
//  Copyright (c) 2013年 Lakesoft. All rights reserved.
//

#import "LKAssetsGroup.h"
#import "LKAsset.h"

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
        }
    }];
}

@end





/*
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
 */




/*
 typedef BOOL (^CategoryFilter)(LKAsset* asset);
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
 */
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
 NSString* const LKAssetsGroupDidChangeCategoryNotification = @"LKAssetsGroupDidChangeCategoryNotification";
 extern NSString * const LKAssetsGroupDidChangeCategoryNotification;

 */
