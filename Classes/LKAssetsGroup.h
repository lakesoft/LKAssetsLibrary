//
//  AssetsGroup.h
//  SlideshowFun
//
//  Created by Hiroshi Hashiguchi on 2013/07/27.
//  Copyright (c) 2013年 Lakesoft. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

// Notifications
extern NSString * const LKAssetsGroupDidReloadNotification;

@class LKAsset;

@interface LKAssetsGroup : NSObject

// Properties (Attributes)
// Note: below properties can be used before calling -reloadAssets
@property (strong, nonatomic, readonly) NSString*   name;
@property (strong, nonatomic, readonly) UIImage*    posterImage;
@property (weak  , nonatomic, readonly) NSURL*      url;
@property (assign, nonatomic, readonly) NSUInteger  type;               // ALAssetsGroupType
@property (assign, nonatomic, readonly) NSInteger   numberOfAssets;

// Properties (Assets)
@property (strong, nonatomic, readonly) NSArray* assets;    // should call -reloadAssets before accessing it

// API
+ (LKAssetsGroup*)assetsGroupFrom:(ALAssetsGroup*)assetsGroup;

- (void)reloadAssets;   // should be called before accessing assets
- (void)unloadAssets;

@end
