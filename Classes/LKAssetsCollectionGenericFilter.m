//
//  LKAssetsCollectorFilter.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/23.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKAssetsCollectionGenericFilter.h"
#import "LKAssetsCollectionEntry.h"
#import "LKAsset.h"

@interface LKAssetsCollectionGenericFilter()
@property (nonatomic, assign) LKAssetsCollectionGenericFilterType type;
@end

@implementation LKAssetsCollectionGenericFilter

+ (instancetype)filterWithType:(LKAssetsCollectionGenericFilterType)type
{
    LKAssetsCollectionGenericFilter* filter = self.new;
    filter.type = type;
    return filter;
}

+ (instancetype)filter
{
    return [self filterWithType:LKAssetsCollectionGenericFilterTypeAll];
}

- (BOOL)_canAdoptAsset:(LKAsset*)asset
{
    if ((_type & LKAssetsCollectionGenericFilterTypeJPEG) && asset.isJPEG) {
        return YES;
    }
    if ((_type & LKAssetsCollectionGenericFilterTypePNG) && asset.isPNG) {
        return YES;
    }
    if ((_type & LKAssetsCollectionGenericFilterTypePhoto) && asset.isPhoto) {
        return YES;
    }
    if ((_type & LKAssetsCollectionGenericFilterTypeVideo) && asset.isVideo) {
        return YES;
    }
    if ((_type & LKAssetsCollectionGenericFilterTypeScreenShot) && asset.isScreenshot) {
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
