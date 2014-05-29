//
//  LKAssetsCollectorFilter.h
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/23.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKAssetsCollectionFilter.h"

typedef NS_ENUM(NSUInteger, LKAssetsCollectionGenericFilterType) {
    LKAssetsCollectionGenericFilterTypePhoto        = (1 << 0),
    LKAssetsCollectionGenericFilterTypeVideo        = (1 << 1),
    LKAssetsCollectionGenericFilterTypeJPEG         = (1 << 2),
    LKAssetsCollectionGenericFilterTypePNG          = (1 << 3),
    LKAssetsCollectionGenericFilterTypeScreenShot   = (1 << 4),
    LKAssetsCollectionGenericFilterTypeAll          = 0xFFFFFFFF,
};

@interface LKAssetsCollectionGenericFilter : NSObject <LKAssetsCollectionFilter>

// Options
@property (nonatomic, assign) BOOL shouldOmitEmptyEntry;    // YES=Omit empty entry / NO=Do not omit (default)

// Factories
+ (instancetype)filter;  // LKAssetsCollectionGenericFilterTypeAll;
+ (instancetype)filterWithType:(LKAssetsCollectionGenericFilterType)type;   // available for bit combinations

@end
