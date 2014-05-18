//
//  LKAssetsDayGroup.h
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LKAsset;
@interface LKAssetsDayGroup : NSObject

@property (assign, nonatomic, readonly) NSInteger yyyymmdd;
@property (strong, nonatomic, readonly) NSArray* assets;
@property (strong, nonatomic, readonly) NSDate* date;

- (id)initWithYYYYMMMDD:(NSInteger)yyyymmdd;
- (void)addAsset:(LKAsset*)asset;

@end
