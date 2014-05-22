//
//  AssetsGroup.h
//  SlideshowFun
//
//  Created by Hiroshi Hashiguchi on 2013/07/27.
//  Copyright (c) 2013年 Lakesoft. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LKAssetsCollection.h"

typedef NS_ENUM(NSInteger, LKAssetsGroupFilter) {
    LKAssetsGroupFilterAllAssets = 1,
    LKAssetsGroupFilterAllPhotos = 2,
    LKAssetsGroupFilterAllVideos = 3
};

typedef NS_ENUM(NSInteger, LKAssetsGroupCategoryType) {
    LKAssetsGroupCategoryTypeAll        = 0,
    LKAssetsGroupCategoryTypePhoto      = 11,
    LKAssetsGroupCategoryTypeVideo      = 12,
    LKAssetsGroupCategoryTypeJPEG       = 21,
    LKAssetsGroupCategoryTypePNG        = 22,
    LKAssetsGroupCategoryTypeScreenShot = 23,
};

extern NSString * const LKAssetsGroupDidChangeCategoryNotification;

@class LKAsset;
@class LKAssetsDayCollection;

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

// API (Assets)
@property (strong, nonatomic, readonly) NSArray* assets;

// Properties (Category)
@property (assign, nonatomic) LKAssetsGroupCategoryType categoryType;

// Properties (Collection)
@property (assign, nonatomic) LKAssetsCollectionType collectionType;
@property (strong, nonatomic, readonly) NSArray* collections;   // <LKAssetsCollection>


// API (Factories)
+ (LKAssetsGroup*)assetsGroupFrom:(ALAssetsGroup*)assetsGroup groupFilter:(LKAssetsGroupFilter)filter;

// API (Operations)
- (void)reload;


//- (NSInteger)indexFromIndexPath:(NSIndexPath*)indexPath assetsSubGroupsType:(LKAssetsCollectionType)collectionType;
//- (NSIndexPath*)indexPathFromIndex:(NSInteger)index assetsSubGroupsType:(LKAssetsGroupCollection)assetsSubGroupType;


// TODO:
//- (NSArray*)shuffledAssets;

@end


@interface LKAssetsGroup (SubGroup)
@end


