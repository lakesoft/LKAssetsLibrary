//
//  FilterViewController.m
//  LKAssetsLibrary
//
//  Created by Hiroshi Hashiguchi on 2014/05/21.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "FilterViewController.h"
#import "CollectionViewController.h"


@implementation FilterViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CollectionViewController* vc = segue.destinationViewController;
    vc.assetsGroup = self.assetsGroup;
}

- (IBAction)changedSegments:(UISegmentedControl*)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 1:
            // JPEG
            self.assetsGroup.categoryType = LKAssetsGroupCategoryTypeJPEG;
            break;
        case 2:
            // Screen
            self.assetsGroup.categoryType = LKAssetsGroupCategoryTypeScreenShot;
            break;
        case 3:
            // video
            self.assetsGroup.categoryType = LKAssetsGroupCategoryTypeVideo;
            break;
        case 0:
        default:
            // All
            self.assetsGroup.categoryType = LKAssetsGroupCategoryTypeAll;
            break;
    }
}

@end
