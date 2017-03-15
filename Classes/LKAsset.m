//
//  Asset.m
//  SlideshowFun
//
//  Created by Hiroshi Hashiguchi on 2013/07/27.
//  Copyright (c) 2013年 Lakesoft. All rights reserved.
//

#import "LKAsset.h"

@interface LKAsset()
@property (strong, nonatomic) ALAsset* asset;
@property (assign, nonatomic) NSInteger dateTimeInteger; // yyyyMMddHH < long max:2147483647
@property (assign, nonatomic) NSTimeInterval timeInterval;
@property (strong, nonatomic) NSString* fileExtension;

// Properties (ALAsset)
@property (strong, nonatomic) NSURL* url;
@property (strong, nonatomic) CLLocation* location;
@property (strong, nonatomic) NSDate* date;
@property (assign, nonatomic) LKAssetType type;
@property (assign, nonatomic) double duration;
@end

@implementation LKAsset

#pragma mark -
#pragma mark Privates (Date formatter)
static NSDateFormatter* _dateFormatter = nil;
+ (void)_setupDateFormatter
{
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_dateFormatter setDateFormat:@"yyyyMMddHH"];
}

#pragma mark -
#pragma mark Basics
- (id)initWithAsset:(ALAsset*)asset
{
    self = super.init;
    if (self) {
        self.asset = asset;
        NSDate* date = self.date;
        self.dateTimeInteger = [_dateFormatter stringFromDate:date].integerValue;
        if (self.dateTimeInteger < 1900000000) {
            self.dateTimeInteger += 1900000000;
        }
        self.timeInterval = date.timeIntervalSince1970;
        self.type = LKAssetTypeUnInitiliazed;
    }
    return self;
}

+ (void)initialize
{
    [self _setupDateFormatter];
}

- (NSComparisonResult)compare:(LKAsset*)asset
{
    if (_timeInterval > asset.timeInterval) {
        return (NSComparisonResult)NSOrderedDescending;
    } if (_timeInterval < asset.timeInterval) {
        return (NSComparisonResult)NSOrderedAscending;
    } else {
        return (NSComparisonResult)NSOrderedSame;
    }
}

- (BOOL)isEqual:(LKAsset*)asset
{
    if (asset == self) {
        return YES;
    }
    if (!asset || ![asset isKindOfClass:self.class]) {
        return NO;
    }
    return [self.url isEqual:asset.url];
}

- (NSUInteger)hash
{
    return [self.url hash];
}


#pragma mark -
#pragma mark Properties (Status)
- (BOOL)deleted
{
    return (self.asset.defaultRepresentation == nil);
}

#pragma mark -
#pragma mark Properties (Image)
- (UIImage*)thumbnail
{
    return [UIImage imageWithCGImage:self.asset.thumbnail];
}

- (UIImage*)aspectRatioThumbnail
{
    return [UIImage imageWithCGImage:self.asset.aspectRatioThumbnail];
}

- (UIImage*)fullScreenImage
{
    ALAssetRepresentation* rep = self.asset.defaultRepresentation;
    if (rep) {
        UIImage *image = [UIImage imageWithCGImage:rep.fullScreenImage
                                             scale:rep.scale
                                       orientation:(UIImageOrientation)rep.orientation];
        return image;
//        UIImage* image = [UIImage imageWithCGImage:rep.fullScreenImage
//                                             scale:1.0
//                                       orientation:(UIImageOrientation)rep.orientation];
//        return [LKImageUtility adjustOrientationImage:image];
    } else {
        // deleted
        return nil;
    }
}

- (UIImage*)fullResolutionImage
{
    ALAssetRepresentation* rep = self.asset.defaultRepresentation;
    if (rep) {
        UIImage* image = [UIImage imageWithCGImage:rep.fullResolutionImage
                                             scale:rep.scale
                                       orientation:0];
        return image;
//        return [LKImageUtility adjustOrientationImage:image];
    } else {
        // deleted
        return nil;
    }
}

#pragma mark -
#pragma mark Properties (ALAsset)
- (NSURL*)url
{
    if (_url == nil) {
        _url = [self.asset valueForProperty:ALAssetPropertyAssetURL];
    }
    return _url;
}

- (CLLocation*)location
{
    if (_location == nil) {
        _location = [self.asset valueForProperty:ALAssetPropertyLocation];
    }
    return _location;
}

- (double)duration
{
    if (_duration == 0 && _type == LKAssetTypeVideo) {
        NSNumber* number = [self.asset valueForProperty:ALAssetPropertyDuration];
        _duration = number.doubleValue;
    }
    return _duration;
}

- (NSDate*)date
{
    if (_date == nil) {
        _date = [self.asset valueForProperty:ALAssetPropertyDate];
    }
    return _date;
}

- (CGSize)size
{
    return self.asset.defaultRepresentation.dimensions;
}

- (LKAssetType)type
{
    if (_type == LKAssetTypeUnInitiliazed) {
        NSString* typeString = [self.asset valueForProperty:ALAssetPropertyType];
        if ([typeString isEqualToString:ALAssetTypePhoto]) {
            self.type = LKAssetTypePhoto;
        } else if ([typeString isEqualToString:ALAssetTypeVideo]) {
            self.type = LKAssetTypeVideo;
        } else if ([typeString isEqualToString:ALAssetTypeUnknown]) {
            self.type = LKAssetTypeUnknown;
        }
    }
    return _type;
}

- (NSString*)fileExtension
{
    if (_fileExtension == nil) {
        _fileExtension = self.url.pathExtension.uppercaseString;
    }
    return _fileExtension;
}

#pragma mark -
#pragma mark Properties (Attribute)
- (BOOL)isJPEG
{
    NSString* fileExtension = self.fileExtension;
    return [fileExtension isEqualToString:@"JPG"] | [fileExtension isEqualToString:@"JPEG"];
}

- (BOOL)isPNG
{
    return [self.fileExtension isEqualToString:@"PNG"];
}

- (BOOL)isVideo
{
    return self.type == LKAssetTypeVideo;
}

- (BOOL)isPhoto
{
    return self.type == LKAssetTypePhoto;
}

- (BOOL)isScreenshot
{

    if (self.isPNG) {
        CGSize size = UIScreen.mainScreen.bounds.size;
        size.width *= UIScreen.mainScreen.scale;
        size.height *= UIScreen.mainScreen.scale;
        return CGSizeEqualToSize(size, self.size);
    }
    return NO;
}


#pragma mark -
#pragma mark APIs
+ (LKAsset*)assetFrom:(ALAsset*)asset
{
    return [[self alloc] initWithAsset:asset];
}


@end
