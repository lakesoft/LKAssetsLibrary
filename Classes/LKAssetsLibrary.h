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
#import "LKAssetsCollectionGenericHelpers.h"

// Notifications (Setup)
extern NSString * const LKAssetsLibraryDidSetupNotification;

// Notifications (Update)
// store updated group into userInfo[LKAssetsLibraryGroupsKey]
extern NSString * const LKAssetsLibraryDidInsertGroupsNotification;
extern NSString * const LKAssetsLibraryDidUpdateGroupsNotification;
extern NSString * const LKAssetsLibraryDidDeleteGroupsNotification;

// Notifications (keys)
extern NSString * const LKAssetsLibraryGroupsKey;


@class LKAssetsGroup;
@interface LKAssetsLibrary : NSObject

// Properties (Group)
@property (weak, nonatomic, readonly) NSArray* assetsGroups;    // <LKAssetsGroup>

// Factories
// assetsGroupType: e.g. ALAssetsGroupLibrary | ALAssetsGroupFaces
// assetsFilter   : ALAssetsFilter.allPhotos, ALAssetsFilter.allVideo, ALAssetsFilter.allAssets
+ (instancetype)assetsLibraryWithAssetsGroupType:(ALAssetsGroupType)assetsGroupType assetsFilter:(ALAssetsFilter*)assetsFilter;

// assetsGroupType: ALAssetsGroupAll
// assetsFilter   : ALAssetsFilter.allAssets
+ (instancetype)assetsLibrary;

// Operations
- (void)reload; // must be called at first

// Authorizations
+ (BOOL)isAuthorizationStatusDenied;

// Exports
@property (strong, nonatomic, readonly) ALAssetsLibrary* assetsLibrary;

// [Option] Group sorting
// default: sorted by group's name in ascending
@property (copy, nonatomic) NSComparisonResult(^sortComparator)(LKAssetsGroup* group1, LKAssetsGroup* group2);


// [Advanced] Custom Group
// default: LKAssetsGroup.class
@property (strong, nonatomic) Class assetsGroupClass;
@end
