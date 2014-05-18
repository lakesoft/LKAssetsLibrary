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
@property (strong, nonatomic) NSArray* dayAssets;

// private
@property (strong, nonatomic) NSMutableArray* temporaryAssets;
@end

@implementation LKAssetsGroup

#pragma mark -
#pragma makr Privates
- (void)_setupDayAssets
{
    NSMutableArray* temporaryAssets = @[].mutableCopy;
    LKAssetsDayGroup* dayGroup = nil;
    NSInteger yyyymmdd = -1;
    for (LKAsset* asset in self.assets) {
        if (asset.yyyymmdd != yyyymmdd) {
            yyyymmdd = asset.yyyymmdd;
            dayGroup = [[LKAssetsDayGroup alloc] initWithYYYYMMMDD:yyyymmdd];
            [temporaryAssets addObject:dayGroup];
        }
        [dayGroup addAsset:asset];
    }
    self.dayAssets = temporaryAssets;
}


#pragma mark -
#pragma mark Basics
- (id)initWithAssetsGroup:(ALAssetsGroup*)assetsGroup
{
    self = super.init;
    if (self) {
        self.assetsGroup = assetsGroup;
        [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
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
- (BOOL)isPhotoStream
{
    return (self.type == ALAssetsGroupPhotoStream);
}



#pragma mark -
#pragma mark Properites (Assets)
- (NSURL*)url
{
    return [self.assetsGroup valueForProperty:ALAssetsGroupPropertyURL];
}
- (NSInteger)type
{
    return ((NSNumber*)[self.assetsGroup valueForProperty:ALAssetsGroupPropertyType]).integerValue;
}


#pragma mark -
#pragma mark APIs
+ (LKAssetsGroup*)assetsGroupFrom:(ALAssetsGroup*)assetsGroup
{
    return [[self alloc] initWithAssetsGroup:assetsGroup];
}

- (LKAssetsGroup*)copyAssetsGroupWithCondition:(BOOL(^)(LKAsset* asset))condition
{
    LKAssetsGroup* newGroup = LKAssetsGroup.new;
    newGroup.assetsGroup = self.assetsGroup;
    NSMutableArray* assets = @[].mutableCopy;
    for (LKAsset* asset in self.assets) {
        if (condition(asset)) {
            [assets addObject:asset];
        }
    }
    newGroup.assets = assets;
    return newGroup;
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
            
            [self _setupDayAssets];
        }
    }];

}



#pragma mark -
#pragma mark Overriden
- (NSString*)description
{
    return self.name;
}

@end
