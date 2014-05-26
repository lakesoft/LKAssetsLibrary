//
//  LKAssetsCollectorSorter.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/23.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKAssetsCollectionSorter.h"
#import "LKAssetsCollectionEntry.h"
#import "LKAsset.h"

@interface LKAssetsCollectionSorter()
@property (nonatomic, assign) LKAssetsCollectionSorterType type;
@end

@implementation LKAssetsCollectionSorter

#pragma mark - Privates

#pragma mark - Factories
+ (instancetype)assetsCollectorSorter
{
    return [self assetsCollectorSorterWithType:LKAssetsCollectionSorterTypeAscending];
}

+ (instancetype)assetsCollectorSorterWithType:(LKAssetsCollectionSorterType)type
{
    LKAssetsCollectionSorter* sorter = self.new;
    sorter.type = type;
    return sorter;
}

// Sorting (customize below)
- (NSArray*)sortedCollectionEntriesWithEntries:(NSArray*)entries
{
    if (self.type == LKAssetsCollectionSorterTypeAscending) {
        return entries;
    } else {
        NSArray* sortedEntries = entries.reverseObjectEnumerator.allObjects;
 
        if (_shouldSortAssetsInEntry) {
            NSMutableArray* newEntries = @[].mutableCopy;
            for (LKAssetsCollectionEntry* entry in sortedEntries) {
                LKAssetsCollectionEntry* newEntry = [LKAssetsCollectionEntry assetsCollectionEntryWithDateTimeInteger:entry.dateTimeInteger assets:entry.assets.reverseObjectEnumerator.allObjects];
                [newEntries addObject:newEntry];
            }
            sortedEntries = newEntries;
        }
        return sortedEntries;
    }
}

@end
