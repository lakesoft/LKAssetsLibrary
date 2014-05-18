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

@interface LKAsset : NSObject

// Properties (Status)
@property (assign, nonatomic, readonly) BOOL deleted;

// Properties (Image)
@property (weak, nonatomic,readonly) UIImage* thumbnail;
@property (weak, nonatomic,readonly) UIImage* aspectRatioThumbnail;
@property (weak, nonatomic,readonly) UIImage* fullScreenImage;
@property (weak, nonatomic,readonly) UIImage* fullResolutionImage;

// Properties (Date number)
@property (assign, nonatomic, readonly) NSTimeInterval timeInterval;
@property (assign, nonatomic, readonly) NSInteger yyyymmdd;
@property (assign, nonatomic, readonly) NSInteger yyyymm;

// Properties (Date description)
@property (weak, nonatomic, readonly) NSString* dateDescription;
@property (weak, nonatomic, readonly) NSString* timeDescription;
@property (weak, nonatomic, readonly) NSString* fullDateDescription;

// Properties (ALAsset)
@property (weak, nonatomic, readonly) NSURL* url;
@property (weak, nonatomic, readonly) CLLocation* location;
@property (strong, nonatomic, readonly) NSDate* date;


// Properties (Attribute)
@property (assign, nonatomic, readonly) BOOL isJPEGPhoto;

// APIs (Factories)
+ (LKAsset*)assetFrom:(ALAsset*)asset;

@end
