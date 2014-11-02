//
//  LKAssetsCollection.h
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/22.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKAssetsCollectionEntry.h"
#import "LKAssetsCollectionGrouping.h"
#import "LKAssetsCollectionFilter.h"
#import "LKAssetsCollectionSorter.h"

@class LKAssetsGroup;
@interface LKAssetsCollection : NSObject

@property (nonatomic, weak  , readonly) LKAssetsGroup* assetsGroup;
@property (nonatomic, strong, readonly) NSArray* entries;   // <LKAssetsCollectionEntry>

@property (nonatomic, strong, readonly) id <LKAssetsCollectionGrouping> grouping;   // nil If created from assets
@property (nonatomic, strong) id <LKAssetsCollectionFilter> filter;
@property (nonatomic, strong) id <LKAssetsCollectionSorter> sorter;

// create with LKAssetsGroup
+ (instancetype)assetsCollectionWithGroup:(LKAssetsGroup*)assetsGroup grouping:(id <LKAssetsCollectionGrouping>)grouping;

// create with LKAsset array
+ (instancetype)assetsCollectionWithAssets:(NSArray*)assets grouping:(id <LKAssetsCollectionGrouping>)grouping;

- (NSInteger)numberOfAssets;

@end

@class LKAsset;
@interface LKAssetsCollection (NSIndexPath)
- (LKAsset*)assetForIndexPath:(NSIndexPath*)indexPath;
- (NSIndexPath*)indexPathForAsset:(LKAsset*)asset;
- (NSIndexPath*)lastIndexPath;

@end

