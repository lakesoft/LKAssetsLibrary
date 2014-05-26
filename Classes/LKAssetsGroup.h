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
@property (strong, nonatomic, readonly) NSString*   name;
@property (strong, nonatomic, readonly) UIImage*    posterImage;
@property (weak  , nonatomic, readonly) NSURL*      url;
@property (assign, nonatomic, readonly) NSUInteger  type;    // ALAssetsGroupType

// Properties (Assets)
// NOTE: Should call -reload before using assets
@property (strong, nonatomic, readonly) NSArray* assets;

// API
+ (LKAssetsGroup*)assetsGroupFrom:(ALAssetsGroup*)assetsGroup;

- (void)reloadAssets;
- (void)unloadAssets;

@end
