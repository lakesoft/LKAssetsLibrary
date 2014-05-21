//
//  LKAssetsSubGroup.h
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/20.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LKAssetsCollectionType) {
    LKAssetsCollectionTypeAll      = 0,
    LKAssetsCollectionTypeMonthly  = 1,
    LKAssetsCollectionTypeDaily    = 2,
    LKAssetsCollectionTypeHourly   = 3,
};

@class LKAsset;
@interface LKAssetsCollection : NSObject

@property (assign, nonatomic, readonly) NSInteger dateTimeInteger;  // yyyymmddHH or yyyymmdd00 or yyyymm0000
@property (strong, nonatomic, readonly) NSDate* date;

- (id)initWithDateTimeInteger:(NSInteger)dateTimeInteger;
- (void)addAsset:(LKAsset*)asset;
- (NSInteger)numberOfAssets;
- (LKAsset*)assetAtIndex:(NSInteger)index;

@end
