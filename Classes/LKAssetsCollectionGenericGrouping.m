//
//  LKAssetsCollectorGrouping.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/23.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKAssetsCollectionGenericGrouping.h"
#import "LKAsset.h"
#import "LKAssetsGroup.h"
#import "LKAssetsCollectionEntry.h"

@interface LKAssetsCollectionGenericGrouping()
@property (nonatomic, assign) LKAssetsCollectionGenericGroupingType type;
@property (nonatomic, assign) NSInteger scale;
@end

@implementation LKAssetsCollectionGenericGrouping

+ (instancetype)grouping
{
    return [self groupingWithType:LKAssetsCollectionGenericGroupingTypeAll];
}

+ (instancetype)groupingWithType:(LKAssetsCollectionGenericGroupingType)type
{
    LKAssetsCollectionGenericGrouping* grouping = self.new;
    grouping.type = type;
    switch (type) {
        case LKAssetsCollectionGenericGroupingTypeYearly:
            grouping.scale = 1000000; // yyyyMMddHH / 1000000 = yyyy
            break;
            
        case LKAssetsCollectionGenericGroupingTypeMonthly:
            grouping.scale = 10000; // yyyyMMddHH / 10000 = yyyyMM
            break;
            
        case LKAssetsCollectionGenericGroupingTypeWeekly:
            // nothing
            break;

        case LKAssetsCollectionGenericGroupingTypeDaily:
            grouping.scale = 100;   // yyyyMMddHH / 100 = yyyyMMdd
            break;

        case LKAssetsCollectionGenericGroupingTypeHourly:
            grouping.scale = 1;     // yyyyMMddHH;
            break;

        case LKAssetsCollectionGenericGroupingTypeAll:
        default:
            break;
    }
    return grouping;
}


- (NSDate*)_weekReferencedDate
{
    NSDateComponents *components = NSDateComponents.new;
    components.year = 1970;
    components.month = 1;
    components.day = 5; // Monday
    NSDate *date = [NSCalendar.currentCalendar dateFromComponents:components];
    return date;
}
- (NSInteger)_dateTimeIntegerOfFirstWeekdayFromDate:(NSDate*)date
{
    NSDateComponents *components = [NSCalendar.currentCalendar components:NSCalendarUnitWeekday
                                                                 fromDate:date];
    NSInteger weekday = components.weekday - 2;   // weekday: 1=Sun ... 7=Sat
    if (weekday < 0) {
        weekday = 7;
    }
    // weekday: 0=Mon ... 6=Sun
    
    NSDate* normalizedDate = [date dateByAddingTimeInterval:-weekday*24*60*60];   // Monday
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
//    NSLog(@" weekday: %zd, normalizedDate: %@", weekday, normalizedDate);
    return [formatter stringFromDate:normalizedDate].integerValue;
}

- (NSArray*)groupedCollectionEntriesWithAssets:(NSArray*)assets
{
    NSMutableArray* entries = @[].mutableCopy;
    __block NSMutableArray* tmpAssets = nil;
    
    if (self.type == LKAssetsCollectionGenericGroupingTypeWeekly) {
        NSInteger previousWeek = 0;
        NSCalendar *calendar = NSCalendar.currentCalendar;
        
        // http://stackoverflow.com/questions/21195926/compute-number-of-weeks-since-epoch-more-accurately-than-days-7
        for (LKAsset* asset in assets) {
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:asset.timeInterval];
            NSInteger week = [calendar components:NSCalendarUnitWeekOfYear
                                         fromDate:self._weekReferencedDate
                                           toDate:date
                                          options:0].weekOfYear;
            if (week != previousWeek) {
                tmpAssets = @[].mutableCopy;
                NSInteger dateTimeInteger = [self _dateTimeIntegerOfFirstWeekdayFromDate:asset.date];
                LKAssetsCollectionEntry* entry = [LKAssetsCollectionEntry assetsCollectionEntryWithDateTimeInteger:dateTimeInteger assets:tmpAssets];
                [entries addObject:entry];
                previousWeek = week;
//                NSLog(@"%05zd : %zd", week, dateTimeInteger);
            }
            [tmpAssets addObject:asset];
        }
        
    } else {
        NSInteger previousDateTimeInteger = 0;
        
        for (LKAsset* asset in assets) {
            if (_scale) {
                if (previousDateTimeInteger != asset.dateTimeInteger/_scale) {
                    previousDateTimeInteger = asset.dateTimeInteger/_scale;
                    tmpAssets = @[].mutableCopy;
                    LKAssetsCollectionEntry* entry = [LKAssetsCollectionEntry assetsCollectionEntryWithDateTimeInteger:previousDateTimeInteger assets:tmpAssets];
                    [entries addObject:entry];
                }
            } else {
                if (previousDateTimeInteger == 0) {
                    tmpAssets = @[].mutableCopy;
                    LKAssetsCollectionEntry* entry = [LKAssetsCollectionEntry assetsCollectionEntryWithDateTimeInteger:previousDateTimeInteger assets:tmpAssets];
                    [entries addObject:entry];
                    previousDateTimeInteger = -1;
                }
            }

            [tmpAssets addObject:asset];
        }
    }
    return entries;
}

@end
