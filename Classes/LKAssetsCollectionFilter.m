//
//  LKAssetsCollectorFilter.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/23.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKAssetsCollectionFilter.h"
#import "LKAssetsCollectionEntry.h"
#import "LKAsset.h"

@interface LKAssetsCollectionFilter()
@property (nonatomic, assign) LKAssetsCollectionFilterType type;
@end

@implementation LKAssetsCollectionFilter

+ (instancetype)assetsCollectorFilterWithType:(LKAssetsCollectionFilterType)type
{
    LKAssetsCollectionFilter* filter = LKAssetsCollectionFilter.new;
    filter.type = type;
    return filter;
}

+ (instancetype)assetsCollectorFilter
{
    return [self assetsCollectorFilterWithType:LKAssetsCollectionFilterTypeAll];
}

- (BOOL)_canAdoptAsset:(LKAsset*)asset
{
    if ((_type & LKAssetsCollectionFilterTypeJPEG) && asset.isJPEG) {
        return YES;
    }
    if ((_type & LKAssetsCollectionFilterTypePNG) && asset.isPNG) {
        return YES;
    }
    if ((_type & LKAssetsCollectionFilterTypePhoto) && asset.isPhoto) {
        return YES;
    }
    if ((_type & LKAssetsCollectionFilterTypeVideo) && asset.isVideo) {
        return YES;
    }
    if ((_type & LKAssetsCollectionFilterTypeScreenShot) && asset.isScreenshot) {
        return YES;
    }
    
    return NO;
}

- (NSArray*)filteredCollectionEntriesWithEntries:(NSArray*)entries
{
    NSMutableArray* filteredEntries = @[].mutableCopy;
    
    for (LKAssetsCollectionEntry* entry in entries) {
        NSMutableArray* assets = @[].mutableCopy;
        for (LKAsset* asset in entry.assets) {
            if ([self _canAdoptAsset:asset]) {
                [assets addObject:asset];
            }
        }
        if (!self.shouldOmitEmptyEntry || assets.count > 0) {
            LKAssetsCollectionEntry* filteredEntry = [LKAssetsCollectionEntry assetsCollectionEntryWithDateTimeInteger:entry.dateTimeInteger assets:assets];
            [filteredEntries addObject:filteredEntry];
        }
    }
    return filteredEntries;
}

@end
