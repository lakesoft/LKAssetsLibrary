//
//  LKAssetsCollectionEntry.h
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/23.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKAssetsCollectionEntry : NSObject

@property (assign, nonatomic, readonly) NSInteger dateTimeInteger;
@property (strong, nonatomic, readonly) NSDate* date;
@property (strong, nonatomic, readonly) NSArray* assets;            // <LKAsset>

+ (instancetype)assetsCollectionEntryWithDateTimeInteger:(NSInteger)dateTimeInteger assets:(NSArray*)assets;

@end
