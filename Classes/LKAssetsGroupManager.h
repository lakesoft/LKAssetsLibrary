//
//  PhotoAlbumManager.h
//  ViewingFun
//
//  Created by Hiroshi Hashiguchi on 2013/07/27.
//  Copyright (c) 2013年 Lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

// Notifications
extern NSString * const LKAssetsGroupManagerDidSetupNotification;
extern NSString * const LKAssetsGroupManagerDidInsertGroupsNotification;
extern NSString * const LKAssetsGroupManagerDidUpdateGroupsNotification;
extern NSString * const LKAssetsGroupManagerDidDeleteGroupsNotification;

// Notifications (keys)
extern NSString * const LKAssetsGroupManagerGroupsKey;


@class LKAssetsGroup;
@interface LKAssetsGroupManager : NSObject

// Properties
@property (weak, nonatomic, readonly) NSArray* assetsGroups;    // <LKAssetsGroup>

// Sorting groups (Option)
typedef NSComparisonResult(^LKAssetsGroupSortComparator)(LKAssetsGroup* group1, LKAssetsGroup* group2);
@property (copy, nonatomic) LKAssetsGroupSortComparator sortComparator;     // default: sorted by group's name in ascending

// API
+ (BOOL)isAuthorizationStatusDenied;


// assetsGroupType: e.g. ALAssetsGroupLibrary | ALAssetsGroupFaces
// assetsFilter   : ALAssetsFilter.allPhotos, ALAssetsFilter.allVideo, ALAssetsFilter.allAssets
+ (instancetype)assetsGroupManagerWithAssetsGroupType:(ALAssetsGroupType)assetsGroupType assetsFilter:(ALAssetsFilter*)assetsFilter;

// assetsGroupType: ALAssetsGroupAll
// assetsFilter   : ALAssetsFilter.allAssets
+ (instancetype)assetsGroupManager;


@end
