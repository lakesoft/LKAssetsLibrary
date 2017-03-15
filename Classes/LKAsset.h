//
//  Asset.h
//  SlideshowFun
//
//  Created by Hiroshi Hashiguchi on 2013/07/27.
//  Copyright (c) 2013年 Lakesoft. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger, LKAssetType) {
    LKAssetTypeUnInitiliazed = -1,
    LKAssetTypeUnknown       =  0,
    LKAssetTypePhoto         =  1,
    LKAssetTypeVideo         =  2
};

@interface LKAsset : NSObject

// Properties (Status)
@property (assign, nonatomic, readonly) BOOL deleted;

// Properties (Image)
@property (weak  , nonatomic, readonly) UIImage* thumbnail;
@property (weak  , nonatomic, readonly) UIImage* aspectRatioThumbnail;
@property (weak  , nonatomic, readonly) UIImage* fullScreenImage;
@property (weak  , nonatomic, readonly) UIImage* fullResolutionImage;

// Properties (Date number)
@property (assign, nonatomic, readonly) NSTimeInterval timeInterval;    // timeIntervalSince1970
@property (assign, nonatomic, readonly) NSInteger dateTimeInteger;      // yyyyMMddHH

// Properties (ALAsset property)
@property (strong, nonatomic, readonly) NSURL* url;
@property (strong, nonatomic, readonly) CLLocation* location;
@property (strong, nonatomic, readonly) NSDate* date;
@property (strong, nonatomic, readonly) NSString* fileExtension;    // upper string JPG, PNG, ...
@property (assign, nonatomic, readonly) CGSize size;
@property (assign, nonatomic, readonly) double duration;            // 0 if photo
@property (assign, nonatomic, readonly) LKAssetType type;

// Properties (Filter)
@property (assign, nonatomic, readonly) BOOL isJPEG;
@property (assign, nonatomic, readonly) BOOL isPNG;
@property (assign, nonatomic, readonly) BOOL isScreenshot;
@property (assign, nonatomic, readonly) BOOL isIOSDeviceScreenshot;
@property (assign, nonatomic, readonly) BOOL isPhoto;
@property (assign, nonatomic, readonly) BOOL isVideo;

// APIs (Factories)
+ (LKAsset*)assetFrom:(ALAsset*)asset;

// Exports
@property (strong, nonatomic, readonly) ALAsset* asset;


// Etc
- (NSComparisonResult)compare:(LKAsset*)asset;

@end
