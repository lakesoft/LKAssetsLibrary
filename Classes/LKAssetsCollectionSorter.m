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
        NSMutableArray* sortedEntries = @[].mutableCopy;
        for (LKAssetsCollectionEntry* entry in entries.reverseObjectEnumerator) {
            [sortedEntries addObject:entry];
        }
        return sortedEntries;
    }
}

@end
