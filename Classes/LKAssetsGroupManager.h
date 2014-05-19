//
//  PhotoAlbumManager.h
//  ViewingFun
//
//  Created by Hiroshi Hashiguchi on 2013/07/27.
//  Copyright (c) 2013年 Lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

extern NSString * const LKAssetsGroupManagerDidSetup;

@class LKAssetsGroup;
@interface LKAssetsGroupManager : NSObject

// Properties
@property (assign, nonatomic, readonly) NSInteger numberOfAssetsGroups;

// API (Setup) * must call at first*
+ (BOOL)isAuthorizationStatusDenied;

// API (Factories)
+ (LKAssetsGroupManager*)sharedManager;

- (void)applyTypeFilter:(ALAssetsGroupType)typeFilter;         // ALAssetsGroupType bit combinations (e.g. ALAssetsGroupLibrary|ALAssetsGroupFaces)
- (void)clearTypeFilter;

- (LKAssetsGroup*)assetsGroupAtIndex:(NSInteger)index;

@end
