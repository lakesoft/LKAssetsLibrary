//
//  LKAssetsCollectionFilter.h
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/29.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LKAssetsCollectionFilter <NSObject>

- (NSArray*)filteredCollectionEntriesWithEntries:(NSArray*)entries; // <LKAssetsCollectionEntry>

@end
