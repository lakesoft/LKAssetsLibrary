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

@class LKAssetsGroup;
@interface LKAssetsGroupManager : NSObject

// Properties
@property (weak, nonatomic, readonly) NSArray* assetsGroups;    // <LKAssetsGroup>

// API
+ (BOOL)isAuthorizationStatusDenied;
+ (instancetype)assetsGroupManager;
+ (instancetype)assetsGroupManagerWithAssetFilter:(ALAssetsFilter*)assetsFilter;

// ALAssetsGroupType bit combinations (e.g. ALAssetsGroupLibrary|ALAssetsGroupFaces)
- (void)applyTypeFilter:(ALAssetsGroupType)typeFilter;
- (void)clearTypeFilter;

@end
