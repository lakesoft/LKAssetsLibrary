//
//  LKAssetsSubGroup.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/20.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKAssetsCollection.h"
#import "LKAssetsGroup.h"

@interface LKAssetsCollection()
@property (assign, nonatomic) NSInteger dateTimeInteger;
@property (strong, nonatomic) NSMutableArray* assets;
@end

@implementation LKAssetsCollection

- (id)initWithDateTimeInteger:(NSInteger)dateTimeInteger
{
    self = [super init];
    if (self) {
        self.dateTimeInteger = dateTimeInteger;
        self.assets = @[].mutableCopy;
    }
    return self;
}

- (NSComparisonResult)compare:(id)other
{
    if ([other isKindOfClass:self.class]) {
        LKAssetsCollection* subGroup = (LKAssetsCollection*)other;
        if (self.dateTimeInteger == subGroup.dateTimeInteger) {
            return NSOrderedSame;
        }
        if (self.dateTimeInteger < subGroup.dateTimeInteger) {
            return NSOrderedAscending;
        }
    }
    return NSOrderedDescending;
}

- (NSString *)description
{
    NSDateFormatter* df = NSDateFormatter.new;
    df.dateStyle = kCFDateFormatterShortStyle;
    df.timeStyle = kCFDateFormatterShortStyle;
    return [NSString stringWithFormat:@"%@, %zdpics", [df stringFromDate:self.date], self.assets.count];
}


#pragma mark - API
- (void)addAsset:(LKAsset*)asset
{
    [self.assets addObject:asset];
}

- (NSInteger)numberOfAssets
{
    return self.assets.count;
}

- (LKAsset*)assetAtIndex:(NSInteger)index
{
    return self.assets[index];
}

@end
