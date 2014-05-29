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

@property (nonatomic, weak  , readonly) LKAssetsGroup* group;
@property (nonatomic, strong, readonly) NSArray* entries;   // <LKAssetsCollectionEntry>

@property (nonatomic, strong, readonly) id <LKAssetsCollectionGrouping> grouping;
@property (nonatomic, strong) id <LKAssetsCollectionFilter> filter;
@property (nonatomic, strong) id <LKAssetsCollectionSorter> sorter;

+ (instancetype)assetsCollectionWithGroup:(LKAssetsGroup*)group grouping:(id <LKAssetsCollectionGrouping>)grouping;

@end


@class LKAsset;
@interface LKAssetsCollection (NSIndexPath)
- (LKAsset*)assetForIndexPath:(NSIndexPath*)indexPath;
@end

