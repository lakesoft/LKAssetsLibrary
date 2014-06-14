//
//  LKAssetsCollectorGrouping.h
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/23.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKAssetsCollectionGrouping.h"

typedef NS_ENUM(NSInteger, LKAssetsCollectionGenericGroupingType) {
    LKAssetsCollectionGenericGroupingTypeAll      = 0,
    LKAssetsCollectionGenericGroupingTypeYearly   = 11,
    LKAssetsCollectionGenericGroupingTypeMonthly  = 12,
    LKAssetsCollectionGenericGroupingTypeWeekly   = 13,    // start with Mon (end with Sun)
    LKAssetsCollectionGenericGroupingTypeDaily    = 14,
    LKAssetsCollectionGenericGroupingTypeHourly   = 15,
};


@interface LKAssetsCollectionGenericGrouping : NSObject <LKAssetsCollectionGrouping>

+ (instancetype)grouping;   // LKAssetsCollectionGenericGroupingTypeAll
+ (instancetype)groupingWithType:(LKAssetsCollectionGenericGroupingType)type;

@end
