//
//  LKImageUtility.h
//  EasyEvernoteClipper
//
//  Created by Hashiguchi Hiroshi on 11/10/04.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;
@interface LKImageUtility : NSObject

+ (UIImage*)adjustOrientationImage:(UIImage*)image;
+ (UIImage*)adjustOrientationImage:(UIImage*)image toWidth:(CGFloat)width;

+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;

+ (NSData *)dataFromImage:(UIImage *)image metadata:(NSDictionary *)metadata quality:(CGFloat)quality;
+ (NSDictionary *)GPSDictionaryForLocation:(CLLocation *)location;

+ (NSInteger)normalizedImageOrientarion:(UIImageOrientation)orientation;

@end
