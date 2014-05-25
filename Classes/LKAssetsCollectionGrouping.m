//
//  LKAssetsCollectorGrouping.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/23.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKAssetsCollectionGrouping.h"
#import "LKAsset.h"
#import "LKAssetsGroup.h"
#import "LKAssetsCollectionEntry.h"

@interface LKAssetsCollectionGrouping()
@property (nonatomic, assign) LKAssetsCollectionGroupingType type;
@property (nonatomic, assign) NSInteger scale;
@property (nonatomic, assign) NSInteger previousDateTimeInteger;
@end

@implementation LKAssetsCollectionGrouping

+ (instancetype)assetsCollectionGrouping
{
    return [self assetsCollectionGroupingWithType:LKAssetsCollectionGroupingTypeAll];
}

+ (instancetype)assetsCollectionGroupingWithType:(LKAssetsCollectionGroupingType)type
{
    LKAssetsCollectionGrouping* grouping = self.new;
    grouping.type = type;
    switch (type) {
        case LKAssetsCollectionGroupingTypeYearly:
            grouping.scale = 1000000; // yyyyMMddHH / 1000000 = yyyy
            break;
            
        case LKAssetsCollectionGroupingTypeMonthly:
            grouping.scale = 10000; // yyyyMMddHH / 10000 = yyyyMM
            break;
            
        case LKAssetsCollectionGroupingTypeDaily:
            grouping.scale = 100;   // yyyyMMddHH / 100 = yyyyMMdd
            break;

        case LKAssetsCollectionGroupingTypeHourly:
            grouping.scale = 1;     // yyyyMMddHH;
            break;

        case LKAssetsCollectionGroupingTypeAll:
        default:
            break;
    }
    return grouping;
}


- (void)_doGroupingWithAsset:(LKAsset*)asset block:(void(^)(NSInteger dateTimeInteger))block
{
    if (_scale) {
        if (_previousDateTimeInteger != asset.dateTimeInteger/_scale) {
            _previousDateTimeInteger = asset.dateTimeInteger/_scale;
            block(_previousDateTimeInteger);
        }
    } else {
        if (_previousDateTimeInteger == 0) {
            block(_previousDateTimeInteger);
            _previousDateTimeInteger = -1;
        }
    }
}

- (NSArray*)collectionEntriesWithAssetsGroup:(LKAssetsGroup*)assetsGroup
{
    NSMutableArray* entries = @[].mutableCopy;
    __block NSMutableArray* assets = nil;
    
    for (LKAsset* asset in assetsGroup.assets) {
        [self _doGroupingWithAsset:asset block:^(NSInteger dateTimeInteger) {
            assets = @[].mutableCopy;
            LKAssetsCollectionEntry* entry = [LKAssetsCollectionEntry assetsCollectionEntryWithDateTimeInteger:dateTimeInteger assets:assets];
            [entries addObject:entry];
        }];
        
        [assets addObject:asset];
    }
    return entries;
}

@end
