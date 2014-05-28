//
//  LKAssetsCollectorSorter.h
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/23.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LKAssetsCollectionSorterType) {
    LKAssetsCollectionSorterTypeAscending = 0,
    LKAssetsCollectionSorterTypeDescending = 1,
};

@interface LKAssetsCollectionSorter : NSObject

// Options
@property (nonatomic, assign) BOOL shouldSortAssetsInEntry;    // YES=Sort assets in entry / NO=Do not sort assets in entry (default)

// Factories
+ (instancetype)assetsCollectorSorter;  //LKAssetsCollectionSorterTypeAscending
+ (instancetype)assetsCollectorSorterWithType:(LKAssetsCollectionSorterType)type;

// Operations (Override in subclass if necessary)
- (NSArray*)sortedCollectionEntriesWithEntries:(NSArray*)entries; // <LKAssetsCollectionEntry>

@end
