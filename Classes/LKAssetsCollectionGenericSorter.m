//
//  LKAssetsCollectorSorter.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/23.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKAssetsCollectionGenericSorter.h"
#import "LKAssetsCollectionEntry.h"
#import "LKAsset.h"

@interface LKAssetsCollectionGenericSorter()
@end

@implementation LKAssetsCollectionGenericSorter

#pragma mark - Privates

#pragma mark - Factories
+ (instancetype)sorterAscending:(BOOL)ascending
{
    LKAssetsCollectionGenericSorter* sorter = self.new;
    sorter.asceding = ascending;
    return sorter;
}

// Sorting (customize below)
- (NSArray*)sortedCollectionEntriesWithEntries:(NSArray*)entries
{
    if (self.isAscending) {
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
