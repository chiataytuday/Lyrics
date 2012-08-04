//
//  PoemsListController.h
//  rPoezie
//
//  Created by Daniel Cristolovean on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Band.h"

@interface PoemsListController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    Band *writer;
    NSArray *poems;
}

@property (nonatomic, strong) Band *writer;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *authorName;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *authorImage;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *addToFavs;

- (IBAction)cmdFavTouchUpInside:(id)sender;
- (IBAction)cmdInfoTouchUpInside:(id)sender;
- (IBAction)home:(id)sender;
- (IBAction)search:(id)sender;
- (IBAction)favorites:(id)sender;
- (IBAction)info:(id)sender;

@end
