//
//  LKAssetsCollectorGrouping.h
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/23.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LKAssetsCollectionGroupingType) {
    LKAssetsCollectionGroupingTypeAll      = 0,
    LKAssetsCollectionGroupingTypeYearly   = 11,
    LKAssetsCollectionGroupingTypeMonthly  = 12,
    LKAssetsCollectionGroupingTypeDaily    = 13,
    LKAssetsCollectionGroupingTypeHourly   = 14,
};


@class LKAssetsGroup;

@interface LKAssetsCollectionGrouping : NSObject

+ (instancetype)assetsCollectionGrouping;   // LKAssetsCollectionGroupingTypeAll
+ (instancetype)assetsCollectionGroupingWithType:(LKAssetsCollectionGroupingType)type;

- (NSArray*)collectionEntriesWithAssetsGroup:(LKAssetsGroup*)assetsGroup;

@end
