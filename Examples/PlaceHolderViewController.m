//
//  PlaceHolderViewController.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/21.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "PlaceHolderViewController.h"
#import "TabBarController.h"
#import "FilterViewController.h"

@interface PlaceHolderViewController ()

@end

@implementation PlaceHolderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%s| %zd", __PRETTY_FUNCTION__, self.tabBarItem.tag);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TabBarController* tbc = (TabBarController*)self.tabBarController;
    FilterViewController* vc = segue.destinationViewController;
    switch (self.tabBarItem.tag) {
        case 1:
            vc.subGroups = tbc.assetsGroup.assetsMonthlyGroups;
            break;
            
        case 3:
            vc.subGroups = tbc.assetsGroup.assetsHourlyGroups;
            break;
            
        case 2:
        default:
            vc.subGroups = tbc.assetsGroup.assetsDailyGroups;
            break;
    }
}

@end
