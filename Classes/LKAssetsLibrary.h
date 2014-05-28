//
//  PhotoAlbumManager.h
//  ViewingFun
//
//  Created by Hiroshi Hashiguchi on 2013/07/27.
//  Copyright (c) 2013年 Lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LKAssetsLibrary.h"
#import "LKAssetsGroup.h"
#import "LKAssetsCollection.h"
#import "LKAsset.h"

// Notifications
extern NSString * const LKAssetsLibraryDidSetupNotification;
extern NSString * const LKAssetsLibraryDidInsertGroupsNotification;
extern NSString * const LKAssetsLibraryDidUpdateGroupsNotification;
extern NSString * const LKAssetsLibraryDidDeleteGroupsNotification;

// Notifications (keys)
extern NSString * const LKAssetsLibraryGroupsKey;


@class LKAssetsGroup;
@interface LKAssetsLibrary : NSObject

// Properties
@property (weak, nonatomic, readonly) NSArray* assetsGroups;    // <LKAssetsGroup>

// Sorting groups (Option)
typedef NSComparisonResult(^LKAssetsGroupSortComparator)(LKAssetsGroup* group1, LKAssetsGroup* group2);
@property (copy, nonatomic) LKAssetsGroupSortComparator sortComparator;     // default: sorted by group's name in ascending

// API
+ (BOOL)isAuthorizationStatusDenied;


// assetsGroupType: e.g. ALAssetsGroupLibrary | ALAssetsGroupFaces
// assetsFilter   : ALAssetsFilter.allPhotos, ALAssetsFilter.allVideo, ALAssetsFilter.allAssets
+ (instancetype)assetsLibraryWithAssetsGroupType:(ALAssetsGroupType)assetsGroupType assetsFilter:(ALAssetsFilter*)assetsFilter;

// assetsGroupType: ALAssetsGroupAll
// assetsFilter   : ALAssetsFilter.allAssets
+ (instancetype)assetsLibrary;


@end
