//
//  LKAssetsCollectorFilter.h
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/23.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, LKAssetsCollectionFilterType) {
    LKAssetsCollectionFilterTypePhoto        = (1 << 0),
    LKAssetsCollectionFilterTypeVideo        = (1 << 1),
    LKAssetsCollectionFilterTypeJPEG         = (1 << 2),
    LKAssetsCollectionFilterTypePNG          = (1 << 3),
    LKAssetsCollectionFilterTypeScreenShot   = (1 << 4),
    LKAssetsCollectionFilterTypeAll          = 0xFFFFFFFF,
};

@class LKAsset;
@interface LKAssetsCollectionFilter : NSObject

// Options
@property (nonatomic, assign) BOOL shouldOmitEmptyEntry;    // YES=Omit empty entry / NO=Do not omit (default)

// Factories
+ (instancetype)assetsCollectorFilter;  // LKAssetsCollectionFilterTypeAll;
+ (instancetype)assetsCollectorFilterWithType:(LKAssetsCollectionFilterType)type;   // available for bit combinations

// Filtering (customize below)
- (NSArray*)filteredCollectionEntriesWithEntries:(NSArray*)entries; // <LKAssetsCollectionEntry>

@end
