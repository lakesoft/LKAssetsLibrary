//
//  LKAssetsSubGroup.h
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/20.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LKAsset;
@interface LKAssetsSubGroup : NSObject

@property (assign, nonatomic, readonly) NSInteger dateTimeInteger;  // yyyymmddHH or yyyymmdd00 or yyyymm0000
@property (strong, nonatomic, readonly) NSDate* date;

- (id)initWithDateTimeInteger:(NSInteger)dateTimeInteger;
- (void)addAsset:(LKAsset*)asset;
- (NSInteger)numberOfAssets;
- (LKAsset*)assetAtIndex:(NSInteger)index;

@end
