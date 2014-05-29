//
//  LKAssetsCollectorGrouping.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/23.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKAssetsCollectionDateGrouping.h"
#import "LKAsset.h"
#import "LKAssetsGroup.h"
#import "LKAssetsCollectionEntry.h"

@interface LKAssetsCollectionDateGrouping()
@property (nonatomic, assign) LKAssetsCollectionDateGroupingType type;
@property (nonatomic, assign) NSInteger scale;
@property (nonatomic, assign) NSInteger previousDateTimeInteger;
@end

@implementation LKAssetsCollectionDateGrouping

+ (instancetype)grouping
{
    return [self groupingWithType:LKAssetsCollectionDateGroupingTypeAll];
}

+ (instancetype)groupingWithType:(LKAssetsCollectionDateGroupingType)type
{
    LKAssetsCollectionDateGrouping* grouping = self.new;
    grouping.type = type;
    switch (type) {
        case LKAssetsCollectionDateGroupingTypeYearly:
            grouping.scale = 1000000; // yyyyMMddHH / 1000000 = yyyy
            break;
            
        case LKAssetsCollectionDateGroupingTypeMonthly:
            grouping.scale = 10000; // yyyyMMddHH / 10000 = yyyyMM
            break;
            
        case LKAssetsCollectionDateGroupingTypeDaily:
            grouping.scale = 100;   // yyyyMMddHH / 100 = yyyyMMdd
            break;

        case LKAssetsCollectionDateGroupingTypeHourly:
            grouping.scale = 1;     // yyyyMMddHH;
            break;

        case LKAssetsCollectionDateGroupingTypeAll:
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

- (NSArray*)groupedCollectionEntriesWithAssetsGroup:(LKAssetsGroup*)assetsGroup
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
