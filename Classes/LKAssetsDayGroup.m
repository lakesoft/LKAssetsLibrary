//
//  LKAssetsDayGroup.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKAssetsDayGroup.h"

@interface LKAssetsDayGroup()
@property (assign, nonatomic) NSInteger yyyymmdd;
@property (strong, nonatomic) NSMutableArray* dayAssets;
@end

@implementation LKAssetsDayGroup

#pragma mark - Basics
- (id)initWithYYYYMMMDD:(NSInteger)yyyymmdd
{
    self = [super init];
    if (self) {
        self.yyyymmdd = yyyymmdd;
        self.dayAssets = @[].mutableCopy;
    }
    return self;
}

- (NSComparisonResult)compare:(id)other
{
    if ([other isKindOfClass:LKAssetsDayGroup.class]) {
        LKAssetsDayGroup* group = (LKAssetsDayGroup*)other;
        if (self.yyyymmdd == group.yyyymmdd) {
            return NSOrderedSame;
        }
        if (self.yyyymmdd < group.yyyymmdd) {
            return NSOrderedAscending;
        }
    }
    return NSOrderedDescending;
}

- (NSString *)description
{
    NSDateFormatter* df = NSDateFormatter.new;
    df.dateStyle = kCFDateFormatterShortStyle;
    df.timeStyle = kCFDateFormatterNoStyle;
    return [NSString stringWithFormat:@"%@, %zdpics", [df stringFromDate:self.date], self.assets.count];
}


#pragma mark - Properties
- (NSArray*)assets
{
    return self.dayAssets;
}

- (NSDate *)date
{
    NSDateFormatter* df = NSDateFormatter.new;
    df.dateFormat = @"yyyymmdd";
    return [df dateFromString:[NSString stringWithFormat:@"%zd", self.yyyymmdd]];
}

#pragma mark - API
- (void)addAsset:(LKAsset*)asset
{
    [self.dayAssets addObject:asset];
}

@end
