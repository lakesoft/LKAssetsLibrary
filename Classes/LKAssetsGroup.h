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
extern NSString * const LKAssetsGroupDidReloadNotification;     // NSNoticication.object == <LKAssetsGroup>

@interface LKAssetsGroup : NSObject

// Properties (Attribute)
// Note: below properties can be used before calling -reloadAssets
@property (strong, nonatomic, readonly) NSString*   name;
@property (strong, nonatomic, readonly) UIImage*    posterImage;
@property (weak  , nonatomic, readonly) NSURL*      url;
@property (assign, nonatomic, readonly) NSUInteger  type;               // ALAssetsGroupType
@property (assign, nonatomic, readonly) NSInteger   numberOfAssets;

// Properties (Asset)
@property (strong, nonatomic, readonly) NSArray* assets;    // should call -reloadAssets before accessing it

// Factories
+ (LKAssetsGroup*)assetsGroupFrom:(ALAssetsGroup*)assetsGroup;

// Operations
- (void)reloadAssets;   // should be called before accessing assets
- (void)unloadAssets;

// Etc
- (NSComparisonResult)compare:(LKAssetsGroup*)assetsGroup;

// Exports
@property (strong, nonatomic, readonly) ALAssetsGroup* assetsGroup;

// [Advanced] Custom Asset
// default: LKAsset.class
@property (strong, nonatomic) Class assetClass;

@end
