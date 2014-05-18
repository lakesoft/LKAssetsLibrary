//
//  PhotoAlbumManager.h
//  ViewingFun
//
//  Created by Hiroshi Hashiguchi on 2013/07/27.
//  Copyright (c) 2013年 Lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LKAssetsGroupManagerDidSetup;

@class LKAssetsGroup;
@interface LKAssetsGroupManager : NSObject

// Properties
@property (assign, nonatomic, readonly) NSInteger numberOfAssetsGroups;

// API (Setup) * must call at first*
+ (BOOL)isAuthorizationStatusDenied;

// API
+ (LKAssetsGroupManager*)sharedManager;

- (LKAssetsGroup*)assetsGroupAtIndex:(NSInteger)index;

@end
