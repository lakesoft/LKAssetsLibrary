//
//  Asset.m
//  SlideshowFun
//
//  Created by Hiroshi Hashiguchi on 2013/07/27.
//  Copyright (c) 2013年 Lakesoft. All rights reserved.
//

#import "LKAsset.h"
#import "LKImageUtility.h"

@interface LKAsset()
@property (strong, nonatomic) ALAsset* asset;
@property (assign, nonatomic) NSInteger yyyymmdd;
@property (assign, nonatomic) NSTimeInterval timeInterval;
@end

@implementation LKAsset

#pragma mark -
#pragma mark Privates (Date formatter)
static NSDateFormatter* _YYYYMMDDDateFormatter = nil;
- (NSInteger)_YYYYMMDDIntegerFromDate:(NSDate*)date
{
    return [_YYYYMMDDDateFormatter stringFromDate:date].integerValue;
}
+ (void)_setupDateFormatter
{
    _YYYYMMDDDateFormatter = [[NSDateFormatter alloc] init];
    _YYYYMMDDDateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_YYYYMMDDDateFormatter setDateFormat:@"yyyyMMdd"];
}

#pragma mark -
#pragma mark Basics
- (id)initWithAsset:(ALAsset*)asset
{
    self = super.init;
    if (self) {
        self.asset = asset;
        NSDate* date = self.date;
        self.yyyymmdd = [self _YYYYMMDDIntegerFromDate:date];
        if (self.yyyymmdd < 19000000) {
            self.yyyymmdd += 19000000;
        }
        self.timeInterval = date.timeIntervalSince1970;
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
        UIImage* image = [UIImage imageWithCGImage:rep.fullResolutionImage
                                             scale:1.0
                                       orientation:(UIImageOrientation)rep.orientation];
        return [LKImageUtility adjustOrientationImage:image];
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
                                             scale:1.0
                                       orientation:(UIImageOrientation)rep.orientation];
        return [LKImageUtility adjustOrientationImage:image];
    } else {
        // deleted
        return nil;
    }
}

#pragma mark -
#pragma mark Properties (Date number)
- (NSInteger)yyyymm
{
    return self.yyyymmdd / 100;
}

#pragma mark -
#pragma mark Properites (Date)
- (NSString*)fullDateDescription
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterLongStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    return [df stringFromDate:self.date];
}

- (NSString*)timeDescription
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"Hm" options:0 locale:[NSLocale currentLocale]]];
    return [df stringFromDate:self.date];
}


#pragma mark -
#pragma mark Properties (ALAsset)
- (NSURL*)url
{
    return [self.asset valueForProperty:ALAssetPropertyAssetURL];
}

- (CLLocation*)location
{
    return [self.asset valueForProperty:ALAssetPropertyLocation];
}

- (NSDate*)date
{
    return [self.asset valueForProperty:ALAssetPropertyDate];
}

#pragma mark -
#pragma mark Properties (Attribute)
- (BOOL)isJPEGPhoto
{
    return [self.url.pathExtension isEqualToString:@"JPG"];
}


#pragma mark -
#pragma mark APIs
+ (LKAsset*)assetFrom:(ALAsset*)asset
{
    return [[self alloc] initWithAsset:asset];
}


@end
