//
//  AssetsGroup.h
//  SlideshowFun
//
//  Created by Hiroshi Hashiguchi on 2013/07/27.
//  Copyright (c) 2013年 Lakesoft. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSInteger, LKAssetsGroupFilter) {
    LKAssetsGroupFilterAllAssets = 1,
    LKAssetsGroupFilterAllPhotos = 2,
    LKAssetsGroupFilterAllVideos = 3
};

typedef NS_ENUM(NSInteger, LKAssetsGroupSubFilter) {
    LKAssetsGroupSubFilterNo         = 0,
    LKAssetsGroupSubFilterPhoto      = 11,
    LKAssetsGroupSubFilterVideo      = 12,
    LKAssetsGroupSubFilterJPEG       = 21,
    LKAssetsGroupSubFilterPNG        = 22,
    LKAssetsGroupSubFilterScreenShot = 23,
};


@class LKAsset;
@class LKAssetsDailyGroup;

@interface LKAssetsGroup : NSObject

// Properties (Attributes)
@property (strong, nonatomic, readonly) NSString* name;
@property (strong, nonatomic, readonly) UIImage* posterImage;
@property (weak  , nonatomic, readonly) NSURL* url;
@property (assign, nonatomic, readonly) NSUInteger type;    // ALAssetsGroupType

// Properties (Types)
@property (assign, nonatomic, readonly) BOOL isLibrary;
@property (assign, nonatomic, readonly) BOOL isAlbum;
@property (assign, nonatomic, readonly) BOOL isEvent;
@property (assign, nonatomic, readonly) BOOL isFaces;
@property (assign, nonatomic, readonly) BOOL isSavedPhoto;
@property (assign, nonatomic, readonly) BOOL isPhotoStream;

// API (Factories)
+ (LKAssetsGroup*)assetsGroupFrom:(ALAssetsGroup*)assetsGroup groupFilter:(LKAssetsGroupFilter)filter;

// API (Operations)
- (void)reload;

// API (Assets)
@property (assign, nonatomic, readonly) NSInteger numberOfAssets;
- (LKAsset*)assetAtIndex:(NSInteger)index;

// API (Sub Groups)
@property (weak, nonatomic, readonly) NSArray* assetsMonthlyGroups;
@property (weak, nonatomic, readonly) NSArray* assetsDailyGroups;
@property (weak, nonatomic, readonly) NSArray* assetsHourlyGroups;


// API (Filter)
- (void)applySubFilter:(LKAssetsGroupSubFilter)subFilter;
- (void)clearSubFilter;


// TODO:
//- (NSArray*)shuffledAssets;

@end


@interface LKAssetsGroup (SubGroup)
@end


