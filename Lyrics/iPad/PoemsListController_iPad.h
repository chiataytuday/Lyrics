//
//  PoemsListController_iPad.h
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Band.h"

@interface PoemsListController_iPad : UIViewController <UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource> {

    UIPopoverController *popOver;
    UIPopoverController *mainPopOver;
    Band *writer;
    NSArray *poems;
    UISegmentedControl *segmentedControl;
}

@property (strong, nonatomic) IBOutlet UIView *viewIntro;
@property (strong, nonatomic) IBOutlet UIView *viewPoems;
@property (strong, nonatomic) IBOutlet UIImageView *authorImage;
@property (strong, nonatomic) IBOutlet UILabel *authorName;
@property (strong, nonatomic) IBOutlet UILabel *authorYears;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *addToFavs;

- (IBAction)addToFavorites:(id)sender;
- (IBAction)seeInformation:(id)sender;

@end
