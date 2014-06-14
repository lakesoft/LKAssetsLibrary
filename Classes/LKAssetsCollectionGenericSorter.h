//
//  LKAssetsCollectorSorter.h
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/23.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKAssetsCollectionSorter.h"

@interface LKAssetsCollectionGenericSorter : NSObject <LKAssetsCollectionSorter>

// Options
@property (nonatomic, assign, getter = isAscending) BOOL asceding;
@property (nonatomic, assign) BOOL shouldSortAssetsInEntry;    // YES=Sort assets in entry / NO=Do not sort assets in entry (default)

// Factories
+ (instancetype)sorterAscending:(BOOL)ascending;

@end
