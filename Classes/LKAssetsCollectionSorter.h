//
//  LKAssetsCollectionSorter.h
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/29.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LKAssetsCollectionSorter <NSObject>

- (NSArray*)sortedCollectionEntriesWithEntries:(NSArray*)entries; // <LKAssetsCollectionEntry>

@end
