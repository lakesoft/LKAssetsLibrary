//
//  LKAssetsCollectionEntry.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/23.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKAssetsCollectionEntry.h"

@interface LKAssetsCollectionEntry()
@property (assign, nonatomic) NSInteger dateTimeInteger;
@property (strong, nonatomic) NSArray* assets;
@end

@implementation LKAssetsCollectionEntry

+ (instancetype)assetsCollectionEntryWithDateTimeInteger:(NSInteger)dateTimeInteger assets:(NSArray*)assets
{
    LKAssetsCollectionEntry* entry = self.new;
    entry.dateTimeInteger = dateTimeInteger;
    entry.assets = assets;
    return entry;
}

- (NSComparisonResult)compare:(LKAssetsCollectionEntry*)other
{
    if ([other isKindOfClass:self.class]) {
        if (self.dateTimeInteger == other.dateTimeInteger) {
            return NSOrderedSame;
        }
        if (self.dateTimeInteger < other.dateTimeInteger) {
            return NSOrderedAscending;
        }
    }
    return NSOrderedDescending;
}

- (NSString *)description
{
    NSString* title = nil;
    if (self.date) {
        NSDateFormatter* df = NSDateFormatter.new;
        df.dateStyle = kCFDateFormatterShortStyle;
        df.timeStyle = kCFDateFormatterShortStyle;
        title = [df stringFromDate:self.date];
    } else {
        title = @"All";
    }
    return [NSString stringWithFormat:@"%@, %zdpics", title, self.assets.count];
}

- (NSDate*)date
{
    NSDateFormatter* df = NSDateFormatter.new;
    if (_dateTimeInteger < 10000) {
        df.dateFormat = @"yyyy";
    } else if (_dateTimeInteger < 1000000) {
            df.dateFormat = @"yyyyMM";
    } else if (_dateTimeInteger < 100000000) {
        df.dateFormat = @"yyyyMMdd";
    } else {
        df.dateFormat = @"yyyyMMddHH";
    }
    return [df dateFromString:[NSString stringWithFormat:@"%zd", _dateTimeInteger]];
}

@end
