//
//  AssetsGroup.h
//  SlideshowFun
//
//  Created by Hiroshi Hashiguchi on 2013/07/27.
//  Copyright (c) 2013年 Lakesoft. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class LKAsset;
@interface LKAssetsGroup : NSObject

// Properties (Attributes)
@property (strong, nonatomic, readonly) NSString* name;
@property (strong, nonatomic, readonly) UIImage* posterImage;
@property (assign, nonatomic, readonly) BOOL isPhotoStream;

// Properties (Assets)
@property (strong, nonatomic, readonly) NSArray* assets;
@property (strong, nonatomic, readonly) NSArray* dayAssets;
@property (weak  , nonatomic, readonly) NSURL* url;
@property (assign, nonatomic, readonly) NSInteger type;

// Properties (Date Sorting)
@property (assign, nonatomic, readonly) NSInteger numberOfDays;

// API (Factories)
+ (LKAssetsGroup*)assetsGroupFrom:(ALAssetsGroup*)assetsGroup;
- (LKAssetsGroup*)copyAssetsGroupWithCondition:(BOOL(^)(LKAsset* asset))condition;

//- (NSArray*)shuffledAssets;

// API (Operations)
- (void)reload;

// API (Date Sorting)

@end
