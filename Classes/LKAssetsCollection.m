//
//  LKAssetsCollection.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/22.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKAssetsCollection.h"
#import "LKAssetsGroup.h"

@interface LKAssetsCollection()
@property (nonatomic, weak) LKAssetsGroup* assetsGroup;
@property (nonatomic, strong) id <LKAssetsCollectionGrouping> grouping;

@property (nonatomic, strong) NSArray* entries;         // <LKAssetsCollectionEntry>
@property (nonatomic, strong) NSArray* processedEntries; // <LKAssetsCollectionEntry>

@end

@implementation LKAssetsCollection

+ (instancetype)assetsCollectionWithGroup:(LKAssetsGroup*)assetsGroup grouping:(id <LKAssetsCollectionGrouping>)grouping
{
    LKAssetsCollection* collection = self.new;
    collection.assetsGroup = assetsGroup;
    collection.grouping = grouping;
    collection.entries = [grouping groupedCollectionEntriesWithAssets:assetsGroup.assets];
    return collection;
}

+ (instancetype)assetsCollectionWithAssets:(NSArray*)assets grouping:(id <LKAssetsCollectionGrouping>)grouping
{
    LKAssetsCollection* collection = self.new;
    collection.entries = [grouping groupedCollectionEntriesWithAssets:assets];
    return collection;
}


- (NSArray*)entries
{
    if (self.filter || self.sorter) {
        return self.processedEntries;
    }
    return _entries;
}

- (NSArray*)processedEntries
{
    if (_processedEntries == nil) {
        NSArray* resultEntries = nil;
        if (self.filter) {
            resultEntries = [self.filter filteredCollectionEntriesWithEntries:_entries];
        } else {
            resultEntries = _entries;
        }
        if (self.sorter) {
            resultEntries = [self.sorter sortedCollectionEntriesWithEntries:resultEntries];
        }        
        _processedEntries = resultEntries;
    }
    return _processedEntries;
}

- (void)setFilter:(id <LKAssetsCollectionFilter>)filter
{
    _filter = filter;
    self.processedEntries = nil;
}

- (void)setSorter:(id <LKAssetsCollectionSorter>)sorter
{
    _sorter = sorter;
    self.processedEntries = nil;
}

- (NSInteger)numberOfAssets
{
    NSInteger numberOfAssets = 0;
    for (LKAssetsCollectionEntry* entry in self.entries) {
        numberOfAssets += entry.assets.count;
    }
    return numberOfAssets;
}


@end


@implementation  LKAssetsCollection (NSIndexPath)

- (LKAsset*)assetForIndexPath:(NSIndexPath*)indexPath
{
    LKAssetsCollectionEntry* entry = self.entries[indexPath.section];
    return entry.assets[indexPath.row];
}

- (NSIndexPath*)indexPathForAsset:(LKAsset*)asset
{
    NSIndexPath* indexPath = nil;
    for (NSInteger section=0; section < self.entries.count; section++) {
        LKAssetsCollectionEntry* entry = self.entries[section];
        NSInteger index = [entry.assets indexOfObject:asset];
        if (index != NSNotFound) {
            indexPath = [NSIndexPath indexPathForItem:index inSection:section];
            break;
        }
    }
    return indexPath;
}

- (NSIndexPath*)lastIndexPath
{
    NSInteger section = self.entries.count - 1;
    if (section < 0) {
        return nil;
    }
    LKAssetsCollectionEntry* entry = self.entries[section];
    NSInteger item = entry.assets.count - 1;
    if (item < 0) {
        return nil;
    }
    return [NSIndexPath indexPathForItem:item inSection:section];
}

@end
