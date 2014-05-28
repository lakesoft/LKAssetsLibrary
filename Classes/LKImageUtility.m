//
//  LKImageUtility.m
//  EasyEvernoteClipper
//
//  Created by Hashiguchi Hiroshi on 11/10/04.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "LKImageUtility.h"
#import <CoreLocation/CoreLocation.h>

@implementation LKImageUtility

+ (UIImage*)adjustOrientationImage:(UIImage*)image
{
    return [self adjustOrientationImage:image toWidth:0];
}

+ (UIImage*)adjustOrientationImage:(UIImage*)image toWidth:(CGFloat)toWidth
{
    CGImageRef imageRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imageRef);
    CGFloat height = CGImageGetHeight(imageRef);

    CGRect bounds = CGRectMake(0, 0, width, height);

    if (toWidth) {
        if (bounds.size.width > toWidth || bounds.size.height > toWidth) {
            CGFloat ratio = width / height;
            
            if (ratio > 1.0) {
                bounds.size.width = toWidth;
                bounds.size.height = toWidth / ratio;
            } else {
                bounds.size.width = toWidth * ratio;
                bounds.size.height = toWidth;
            }
        }
    }
    
    CGFloat scale = bounds.size.width / width;
    CGAffineTransform transform;
    CGFloat tmp;

    switch (image.imageOrientation) {
        case UIImageOrientationUp:              // EXIF: 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored:      // EXIF: 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:            // EXIF: 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:    // EXIF: 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored:    // EXIF: 5
            tmp = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = tmp;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft:            // EXIF: 6
            tmp = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = tmp;
            transform = CGAffineTransformMakeTranslation(0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:   // EXIF: 7
            tmp = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = tmp;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:           // EXIF: 8
            tmp = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = tmp;
            transform = CGAffineTransformMakeTranslation(height, 0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            break;
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (image.imageOrientation == UIImageOrientationRight ||
        image.imageOrientation == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scale, scale);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scale, -scale);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();
    
    return resultImage;
}


/*
 * UIImageのクロップの方法（How to crop a UIImage）
 * http://blog.k-jee.com/2010/01/uiimagehow-to-crop-uiimage.html
 */
+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect(
                                                       [imageToCrop CGImage], rect);
    UIImage *cropped =[UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

// http://dev.classmethod.jp/smartphone/iphone/uiimagepickercontroller-exifgps/
+ (NSData *)dataFromImage:(UIImage *)image metadata:(NSDictionary *)metadata quality:(CGFloat)quality
{
    NSMutableData *imageData = [NSMutableData new];
    CGImageDestinationRef dest = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)imageData, kUTTypeJPEG, 1, NULL);
    CGImageDestinationSetProperties(dest, (__bridge CFDictionaryRef)@{
                                                                      (NSString*)kCGImageDestinationLossyCompressionQuality:
                                                                          @(quality)
                                                                      });

    CGImageDestinationAddImage(dest, image.CGImage, (__bridge CFDictionaryRef)metadata);
    CGImageDestinationFinalize(dest);
    CFRelease(dest);
    
    return imageData;
}


+ (NSDateFormatter *)_GPSDateFormatter
{
    static NSDateFormatter *dateFormatter;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy:MM:dd";
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    }
    
    return dateFormatter;
}

+ (NSDateFormatter *)_GPSTimeFormatter
{
    static NSDateFormatter *dateFormatter;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm:ss.SSSSSS";
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    }
    
    return dateFormatter;
}

+ (NSDictionary *)GPSDictionaryForLocation:(CLLocation *)location
{
    NSMutableDictionary *gps = [NSMutableDictionary new];
    
    gps[(NSString *)kCGImagePropertyGPSDateStamp] = [self._GPSDateFormatter stringFromDate:location.timestamp];
    gps[(NSString *)kCGImagePropertyGPSTimeStamp] = [self._GPSTimeFormatter stringFromDate:location.timestamp];
    
    CGFloat latitude = location.coordinate.latitude;
    NSString *gpsLatitudeRef;
    if (latitude < 0) {
        latitude = -latitude;
        gpsLatitudeRef = @"S";
    } else {
        gpsLatitudeRef = @"N";
    }
    gps[(NSString *)kCGImagePropertyGPSLatitudeRef] = gpsLatitudeRef;
    gps[(NSString *)kCGImagePropertyGPSLatitude] = @(latitude);
    
    CGFloat longitude = location.coordinate.longitude;
    NSString *gpsLongitudeRef;
    if (longitude < 0) {
        longitude = -longitude;
        gpsLongitudeRef = @"W";
    } else {
        gpsLongitudeRef = @"E";
    }
    gps[(NSString *)kCGImagePropertyGPSLongitudeRef] = gpsLongitudeRef;
    gps[(NSString *)kCGImagePropertyGPSLongitude] = @(longitude);
    
    CGFloat altitude = location.altitude;
    if (!isnan(altitude)){
        NSString *gpsAltitudeRef;
        if (altitude < 0) {
            altitude = -altitude;
            gpsAltitudeRef = @"1";
        } else {
            gpsAltitudeRef = @"0";
        }
        gps[(NSString *)kCGImagePropertyGPSAltitudeRef] = gpsAltitudeRef;
        gps[(NSString *)kCGImagePropertyGPSAltitude] = @(altitude);
    }
    
    return gps;
}

+ (NSInteger)normalizedImageOrientarion:(UIImageOrientation)orientation {
    int result = 1;
    switch (orientation) {
        case UIImageOrientationUp:
            result = 1;
            break;
            
        case UIImageOrientationDown:
            result = 3;
            break;
            
        case UIImageOrientationLeft:
            result = 8;
            break;
            
        case UIImageOrientationRight:
            result = 6;
            break;
            
        case UIImageOrientationUpMirrored:
            result = 2;
            break;
            
        case UIImageOrientationDownMirrored:
            result = 4;
            break;
            
        case UIImageOrientationLeftMirrored:
            result = 5;
            break;
            
        case UIImageOrientationRightMirrored:
            result = 7;
            break;
    }
    return result;
}
@end
