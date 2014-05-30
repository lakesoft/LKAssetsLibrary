//
//  LKAssetsCollectorGrouping.h
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/23.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKAssetsCollectionGrouping.h"

typedef NS_ENUM(NSInteger, LKAssetsCollectionDateGroupingType) {
    LKAssetsCollectionDateGroupingTypeAll      = 0,
    LKAssetsCollectionDateGroupingTypeYearly   = 11,
    LKAssetsCollectionDateGroupingTypeMonthly  = 12,
    LKAssetsCollectionDateGroupingTypeWeekly   = 13,    // start with Mon (end with Sun)
    LKAssetsCollectionDateGroupingTypeDaily    = 14,
    LKAssetsCollectionDateGroupingTypeHourly   = 15,
};


@interface LKAssetsCollectionDateGrouping : NSObject <LKAssetsCollectionGrouping>

+ (instancetype)grouping;   // LKAssetsCollectionDateGroupingTypeAll
+ (instancetype)groupingWithType:(LKAssetsCollectionDateGroupingType)type;

@end
