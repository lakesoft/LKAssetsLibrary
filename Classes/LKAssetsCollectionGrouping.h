//
//  LKAssetsCollectionGrouping.h
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/29.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  LKAssetsGroup;
@protocol LKAssetsCollectionGrouping <NSObject>

- (NSArray*)groupedCollectionEntriesWithAssets:(NSArray*)assets;

@end
